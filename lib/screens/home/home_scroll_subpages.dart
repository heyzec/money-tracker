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
  int? currentPageIndex;
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print("Build: HomeScrollSubpages()");

    // Use read() to not trigger rebuild when start date alone changes
    DateTime startDate =
        ref.read(appStateProvider.select((appState) => appState.startDate));
    Period period =
        ref.watch(appStateProvider.select((appState) => appState.period));

    double viewportWidth = MediaQuery.of(context).size.width;

    const double headerRatio = 0.5;

    double translate(pageControllerOffset) {
      double scaled = pageControllerOffset * headerRatio;
      // (w-rw)/2 is the size of remaining space, we minus this amount
      // wr is the size of one more page, we need to shift indexes by 1 because ListView cannot render -1th page
      double offset = viewportWidth * ((3 * headerRatio - 1) / 2);
      double scrollControllerOffset = scaled + offset;
      return scrollControllerOffset;
    }

    var dateExtent = ref.watch(dateExtentProvider);
    return dateExtent.when(
      data: (dateExtent) {
        int initialPageIndex = period.countPeriods(startDate, dateExtent.start);
        if (currentPageIndex != null && currentPageIndex == initialPageIndex) {
          // Rebuild not caused by changing of periods.
        } else {
          // Rebuild caused by changing of periods.
          Future(() {
            pageController.jumpToPage(initialPageIndex);
            scrollController.jumpTo(translate(pageController.offset));
          });
          setState(() {
            currentPageIndex = initialPageIndex;
          });
        }
        if (!pageController.hasClients) {
          pageController.addListener(() {
            // controller2!.animateTo(offset, duration: Duration(milliseconds: 50), curve: Curves.linear);
            scrollController.jumpTo(translate(pageController.offset));
          });
        }

        int lastPageIndex = period.countPeriods(
          maxForDates(dateExtent.end, DateTime.now()),
          dateExtent.start,
        );
        // Seems that this PageView will be cached by Flutter on rebuilds
        // even when the itemCount changes
        return Column(
          children: [
            SizedBox(
              width: viewportWidth,
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: lastPageIndex + 3,
                controller: scrollController,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: viewportWidth * headerRatio,
                    child: (index == 0 || index == lastPageIndex + 2)
                        ? Container(color: Colors.black)
                        : Container(
                            color: Colors.red[index * 100 + 100],
                            child: Text((index - 1).toString()),
                          ),
                  );
                },
              ),
            ),
            Expanded(
              child: PageView.builder(
                allowImplicitScrolling: true,
                itemCount: lastPageIndex + 1,
                scrollDirection: Axis.horizontal,
                controller: pageController,
                onPageChanged: (newIndex) {
                  Future(() {
                    if (newIndex > currentPageIndex!) {
                      ref.read(appStateProvider.notifier).increment();
                    }
                    if (newIndex < currentPageIndex!) {
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

                  return SizedBox(
                    width: viewportWidth,
                    child: HomeScrollSubpage(pageIndex: index, query: query),
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (_, __) => Placeholder(),
      loading: () => Placeholder(),
    );
  }
}
