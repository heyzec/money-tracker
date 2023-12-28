import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/screens/home/home_scroll_subpage.dart';
import 'package:namer_app/utils/dates.dart';
import 'package:namer_app/utils/providers.dart';
import 'package:namer_app/utils/types.dart';

class HomeScrollSubpages extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScrollSubpages> createState() =>
      _HomeScrollableSectionState();
}

class _HomeScrollableSectionState extends ConsumerState<HomeScrollSubpages> {
  late int currentPageIndex;

  @override
  Widget build(BuildContext context) {
    print("Build: HomeScrollSubpages()");

    // TODO: Consider making all pages have the same controller instance
    PageController? controller;

    // Use read() to not trigger rebuild when start date alone changes
    DateTime startDate =
        ref.read(appStateProvider.select((appState) => appState.startDate));
    Period period =
        ref.watch(appStateProvider.select((appState) => appState.period));

    double viewportWidth = MediaQuery.of(context).size.width;

    var dateExtent = ref.watch(dateExtentProvider);

    DateTime maxForDates(DateTime date1, DateTime date2) =>
        date1.isAfter(date2) ? date1 : date2;

    return dateExtent.when(
      data: (dateExtent) {
        int initialPageIndex = period.countPeriods(startDate, dateExtent.start);
        if (controller == null) {
          // print("Creating new controller with index: $initialPageIndex");
          controller = PageController(initialPage: initialPageIndex);
          currentPageIndex = initialPageIndex;
        } else {}
        // print("jump to $initialPageIndex");
        // _controller!.onAttach!(() {});

        DateTime temp = maxForDates(dateExtent.end, DateTime.now());
        int lastPageIndex = period.countPeriods(
          temp,
          dateExtent.start,
        );
        // Seems that this PageView will be cached by Flutter on rebuilds
        // even when the itemCount changes
        return PageView.builder(
          allowImplicitScrolling: true,
          itemCount: lastPageIndex + 1,
          scrollDirection: Axis.horizontal,
          controller: controller,
          onPageChanged: (newIndex) {
            Future(() {
              if (newIndex > currentPageIndex) {
                ref.read(appStateProvider.notifier).increment();
              }
              if (newIndex < currentPageIndex) {
                ref.read(appStateProvider.notifier).decrement();
              }
              setState(() {
                currentPageIndex = newIndex;
              });
            });
          },
          itemBuilder: (context, index) {
            Query query = Query.generateQuery(
              pageIndex: index,
              baseDate: period.coerceDate(dateExtent.start),
              period: period,
            );

            return Container(
              width: viewportWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 1.0,
                ),
              ),
              child: HomeScrollSubpage(pageIndex: index, query: query),
            );
          },
        );
      },
      error: (_, __) => Placeholder(),
      loading: () => Placeholder(),
    );
  }
}
