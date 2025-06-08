import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PagedWall<T> extends StatelessWidget {
  final PagingController<int, T> pagingController;
  final Widget Function(BuildContext, T, int) itemBuilder;

  const PagedWall({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.toInt();
        var colCnt = (width + 100) ~/ 300 + 3;

        return PagingListener(
          controller: pagingController,
          builder: (context, state, fetchNextPage) => PagedGridView<int, T>(
            state: state,
            fetchNextPage: fetchNextPage,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: colCnt,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: width < 500 ? 1 : 1.5
            ),
            scrollDirection: Axis.vertical,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: itemBuilder
            )
          )
        );
      }
    );
  }
}