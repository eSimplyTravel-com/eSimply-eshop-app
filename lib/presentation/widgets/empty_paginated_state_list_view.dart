import "dart:async";
import "dart:developer";

import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/presentation/helpers/native_indicator.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/widgets/empty_state_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

typedef IndexedWidgetBuilder = Widget Function(BuildContext, int);

class EmptyPaginatedStateListView<T> extends StatefulWidget {
  const EmptyPaginatedStateListView({
    required this.emptyStateWidget,
    required this.paginationService,
    required this.builder,
    required this.onRefresh,
    required this.onLoadItems,
    required this.separatorBuilder,
    this.loadingWidget,
    super.key,
  });
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadItems;
  final Function(T item) builder;
  final EmptyStateWidget emptyStateWidget;
  final IndexedWidgetBuilder separatorBuilder;
  final PaginationService<T> paginationService;
  final Widget? loadingWidget;

  @override
  State<EmptyPaginatedStateListView<T>> createState() =>
      _EmptyPaginatedStateListViewState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has("onRefresh", onRefresh),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          "onLoadItems",
          onLoadItems,
        ),
      )
      ..add(ObjectFlagProperty<Function(T item)>.has("builder", builder))
      ..add(
        ObjectFlagProperty<IndexedWidgetBuilder>.has(
          "separatorBuilder",
          separatorBuilder,
        ),
      )
      ..add(
        DiagnosticsProperty<PaginationService<T>>(
          "paginationService",
          paginationService,
        ),
      );
  }
}

class _EmptyPaginatedStateListViewState<T>
    extends State<EmptyPaginatedStateListView<T>> {
  @override
  void initState() {
    super.initState();
    bool getDataFirstTime = widget.paginationService.notifier.items.isEmpty &&
        !widget.paginationService.notifier.isLoading &&
        widget.paginationService.notifier.currentPage == 1;

    if (getDataFirstTime) {
      unawaited(widget.onLoadItems());
    }

    log("EmptyPaginatedStateListView initState: start");
    widget.paginationService.addListener(() {
      log(
        "EmptyPaginatedStateListView initState: start state: ${widget.paginationService.notifier}",
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Put your state-changing logic here
        setState(() {
          // Update state safely
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    log(
      "EmptyPaginatedStateListView: state: ${widget.paginationService.notifier}",
    );

    if (_shouldShowEmptyState()) {
      return _buildEmptyState();
    }

    if (_shouldShowInitialLoading()) {
      return _buildInitialLoadingState(context);
    }

    return _buildListView();
  }

  bool _shouldShowEmptyState() {
    return widget.paginationService.notifier.items.isEmpty &&
        !widget.paginationService.notifier.isLoading;
  }

  bool _shouldShowInitialLoading() {
    return widget.paginationService.notifier.isLoading &&
        widget.paginationService.notifier.items.isEmpty;
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: Center(child: widget.emptyStateWidget),
    );
  }

  Widget _buildInitialLoadingState(BuildContext context) {
    return widget.loadingWidget ??
        Center(
          child: SizedBox(
            width: 35,
            height: 35,
            child: getNativeIndicator(context),
          ),
        );
  }

  Widget _buildListView() {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.paginationService.notifier.items.length +
            (widget.paginationService.notifier.hasMore ? 1 : 0),
        itemBuilder: _buildListItem,
        separatorBuilder: widget.separatorBuilder,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (_isLoadMoreIndicatorIndex(index)) {
      return _buildLoadMoreIndicator();
    }

    T item = widget.paginationService.notifier.items[index];
    return widget.builder(item);
  }

  bool _isLoadMoreIndicatorIndex(int index) {
    return index == widget.paginationService.notifier.items.length &&
        widget.paginationService.notifier.hasMore;
  }

  Widget _buildLoadMoreIndicator() {
    log("EmptyPaginatedStateListView load items");
    unawaited(widget.onLoadItems());

    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<IndexedWidgetBuilder?>.has(
          "separatorBuilder",
          widget.separatorBuilder,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          "onRefresh",
          widget.onRefresh,
        ),
      )
      ..add(
        DiagnosticsProperty<PaginatedData<dynamic>>(
          "state",
          widget.paginationService.notifier,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          "onLoadItems",
          widget.onLoadItems,
        ),
      )
      ..add(
        ObjectFlagProperty<Function(T item)>.has("builder", widget.builder),
      );
  }
}

@AppPreview(name: "Empty Paginated State List View")
Widget emptyPaginatedStateListViewPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: EmptyPaginatedStateListView<String>(
        paginationService: PaginationService<String>(),
        emptyStateWidget: const EmptyStateWidget(
          title: "Nothing here yet",
          content: "Pull to refresh once content is available.",
        ),
        builder: (String item) => ListTile(title: Text(item)),
        onRefresh: () async {},
        onLoadItems: () async {},
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox.shrink(),
      ),
    ),
  );
}
