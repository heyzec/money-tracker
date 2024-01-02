import 'dart:math';

import 'package:flutter/material.dart';

/// A wrapper round Stepper to abstract the handling of transition between step states
/// as well as for consistency of layout of widgets in each step.
class WrappedStepper extends StatefulWidget {
  final List<WrappedStep> steps;

  const WrappedStepper({required this.steps});

  @override
  State<WrappedStepper> createState() => _WrappedStepperState();
}

class _WrappedStepperState extends State<WrappedStepper> {
  int index = 0;
  int highestIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Step> newSteps = [];

    int nSteps = widget.steps.length;
    for (int i = 0; i < nSteps; i++) {
      WrappedStep step = widget.steps[i];
      newSteps.add(
        Step(
          title: DefaultTextStyle.merge(
            style: i <= highestIndex ? null : TextStyle(color: Colors.grey),
            child: widget.steps[i].title,
          ),
          content: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                step.instructionArea,
                SizedBox(height: 10),
                Row(
                  children: step.additionalButtons
                          .expand(
                            (element) => [element] + [SizedBox(width: 10)],
                          )
                          .toList() +
                      [
                        FilledButton(
                          onPressed: !step.enableContinueButton
                              ? null
                              : () {
                                  if (step.onPressed != null) {
                                    step.onPressed!();
                                  }
                                  setState(() {
                                    if (index < nSteps - 1) {
                                      index += 1;
                                    }
                                    highestIndex = max(highestIndex, index);
                                  });
                                },
                          child:
                              i < nSteps - 1 ? Text('Continue') : Text("Done"),
                        ),
                      ],
                ),
                if (step.feedbackArea != null) SizedBox(height: 10),
                if (step.feedbackArea != null) step.feedbackArea!,
              ],
            ),
          ),
        ),
      );
    }

    return Stepper(
      controlsBuilder: (_, __) => Text(""),
      onStepTapped: (stepNo) {
        if (stepNo <= highestIndex) {
          setState(() {
            index = stepNo;
          });
        }
      },
      currentStep: index,
      steps: newSteps,
    );
  }
}

/// A wrapper around Step to enscapsulate the information needed
/// to layout widgets in each step.
class WrappedStep {
  Widget title;
  Widget instructionArea;
  List<Widget> additionalButtons;
  Widget? feedbackArea;

  bool enableContinueButton;
  VoidCallback? onPressed;

  WrappedStep({
    required this.title,
    required this.instructionArea,
    required this.enableContinueButton,
    this.onPressed,
    this.additionalButtons = const [],
    this.feedbackArea,
  });
}
