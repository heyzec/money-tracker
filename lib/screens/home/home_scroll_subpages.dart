import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:namer_app/screens/home/home_scroll_subpage.dart';
import 'package:namer_app/utils/query_provider.dart';

class HomeScrollSubpages extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScrollSubpages> createState() =>
      _HomeScrollableSectionState();
}

class _HomeScrollableSectionState extends ConsumerState<HomeScrollSubpages> {
  final InfiniteScrollController _controller = InfiniteScrollController();

  @override
  Widget build(BuildContext context) {
    ref.watch(queryPrecursorProvider);
    if (_controller.hasClients) {
      // When QueryPrecursor updates, reset page index to 0
      _controller.jumpTo(0.0);
    }

    double viewportWidth = MediaQuery.of(context).size.width;

    return InfiniteListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _controller,
      physics: PageScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          width: viewportWidth,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 1.0,
            ),
          ),
          child: HomeScrollSubpage(index),
        );
      },
    );
  }
}
