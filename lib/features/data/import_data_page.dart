import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart' as csv;
import 'package:csv/csv_settings_autodetection.dart' as csv_detection;
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/db/database.dart';
import 'package:money_tracker/utils/providers.dart';
import 'package:money_tracker/widgets/wrapped_stepper.dart';
import 'package:path/path.dart' as p;

typedef Result<T> = ({String? error, T? result});

typedef CsvResult = List<List<dynamic>>;
typedef StepOneResult = ({
  String filename,
  CsvResult result,
});

typedef ParsedRow = ({
  DateTime date,
  int amount,
  String remarks,
  String categoryName,
});
typedef StepTwoResult = List<ParsedRow>;

class ImportDataPage extends ConsumerStatefulWidget {
  const ImportDataPage({super.key});

  @override
  ConsumerState<ImportDataPage> createState() => _ImportState();
}

class _ImportState extends ConsumerState<ImportDataPage> {
  Result<StepOneResult> stepOneResult =
      (error: "No file selected", result: null);
  Result<StepTwoResult> stepTwoResult = (error: null, result: null);

  StreamController<double> progress = StreamController();
  bool importStarted = false;

  @override
  Widget build(BuildContext context) {
    AppDatabase database = ref.read(databaseProvider);

    WrappedStep stepOne = WrappedStep(
      enableContinueButton: stepOneResult.error == null,
      onPressed: () {
        doStepTwo();
      },
      title: Text("Select file"),
      instructionArea: Text("Please ensure it is correct!"),
      additionalButtons: [
        OutlinedButton.icon(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result == null) {
              return;
            }
            File file = File(result.files.single.path!);
            doStepOne(file);
          },
          icon: Icon(Icons.file_open),
          label: Text("Select file"),
        ),
      ],
      feedbackArea: (stepOneResult.error != null)
          ? Text(stepOneResult.error!)
          : stepOneResult.result != null
              ? Text("Selected: ${stepOneResult.result!.filename}")
              : null,
    );

    WrappedStep stepTwo = WrappedStep(
      enableContinueButton: stepTwoResult.error == null,
      title: Text("Edit details"),
      instructionArea: Column(
        children: [
          Text("Number of rows: ${stepTwoResult.result?.length}"),
        ],
      ),
      feedbackArea:
          (stepTwoResult.error != null) ? Text(stepTwoResult.error!) : null,
    );

    WrappedStep stepThree = WrappedStep(
      enableContinueButton: true,
      title: Text("Import"),
      instructionArea: Text(
        "Press start to begin the import process. This may take a while.",
      ),
      additionalButtons: [
        OutlinedButton(
          onPressed: importStarted
              ? null
              : () async {
                  setState(() {
                    importStarted = true;
                  });
                  doStepThree(database, stepTwoResult.result!);
                },
          child: Text("Start"),
        ),
      ],
      feedbackArea: StreamBuilder<double>(
        stream: progress.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return LinearProgressIndicator(
            value: snapshot.data,
            semanticsLabel: 'Linear progress indicator',
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import data'),
      ),
      body: WrappedStepper(
        steps: [
          stepOne,
          stepTwo,
          stepThree,
        ],
      ),
    );
  }

  void doStepOne(File? file) {
    if (file == null) {
      setState(() {
        stepOneResult = (error: null, result: null);
      });
      return;
    }

    String basename = p.basename(file.path);
    if (!basename.endsWith('.csv')) {
      setState(() {
        stepOneResult = (error: "File does not end with .csv!", result: null);
      });
      return;
    }

    csv.CsvToListConverter converter = csv.CsvToListConverter(
      csvSettingsDetector: csv_detection.FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'],
      ),
    );

    String lines = file.readAsStringSync();
    CsvResult rows = converter.convert(lines);

    if (rows.isEmpty) {
      setState(() {
        stepOneResult = (error: "File is empty!", result: null);
      });
      return;
    }

    setState(() {
      stepOneResult = (error: null, result: (result: rows, filename: basename));
    });
  }

  void doStepTwo() {
    CsvResult rows = stepOneResult.result!.result;
    Map<String, int> map = {};
    List<dynamic> headers = rows[0];
    for (int i = 0; i < headers.length; i++) {
      String header = headers[i];
      map[header] = i;
    }

    String? error;
    for (var header in ['amount', 'date', 'category', 'description']) {
      if (!map.containsKey(header)) {
        error = "File is missing '$header' header";
      }
    }
    if (error != null) {
      setState(() {
        stepTwoResult = (error: error, result: null);
      });
    }

    List<ParsedRow> output = [];

    int i = 1;
    List<dynamic>? row;
    try {
      for (; i < rows.length; i++) {
        row = rows[i];
        dynamic amountString = row[map['amount']!];
        String dateString = row[map['date']!];
        String category = row[map['category']!];
        String description = row[map['description']!];

        if (amountString is String) {
          //warn
          amountString = amountString.replaceAll(',', '');
          amountString = double.parse(amountString);
        }
        int amount = ((amountString as num) * 100).round();

        DateTime date = DateFormat('d/M/y').parse(dateString);

        output.add(
          (
            date: date,
            amount: amount,
            remarks: description,
            categoryName: category,
          ),
        );
      }
    } catch (e) {
      String msg = "An error occured on row $i - ";
      msg += row.toString();
      msg += e.toString();
      setState(() {
        stepTwoResult = (error: msg, result: null);
      });
      return;
    }
    setState(() {
      stepTwoResult = (error: null, result: output);
    });
  }

  Future<void> doStepThree(AppDatabase database, List<ParsedRow> parsed) async {
    int total = parsed.length;
    int failure = 0;

    try {
      for (int i = 0; i < total; i++) {
        try {
          ParsedRow record = parsed[i];
          // Can fail if no category found
          await database.insertTransaction(
            date: record.date,
            amount: record.amount,
            remarks: record.remarks,
            categoryName: record.categoryName,
          );
          progress.add(i / parsed.length);
        } on DriftRemoteException catch (e) {
          if (e.remoteCause.runtimeType != SqliteException) {
            rethrow;
          }
          print("Ignoring row $i because ${e.remoteCause}");
          failure += 1;
        }
      }
    } catch (e) {
      print(e);
      print(e.toString());
      print("fatal");
    }
    progress.add(1.0);
    print("${total - failure} / $total added.");
  }
}
