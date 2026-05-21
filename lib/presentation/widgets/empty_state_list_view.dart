import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

typedef IndexedWidgetBuilder = Widget Function(BuildContext, int);

class EmptyStateListView<T> extends StatelessWidget {
  const EmptyStateListView({
    required this.items,
    required this.emptyStateWidget,
    required this.itemBuilder,
    this.onRefresh,
    this.separatorBuilder,
    super.key,
  });
  final List<T> items;
  final SizedBox emptyStateWidget;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? RefreshIndicator(
            onRefresh: () async {
              onRefresh?.call();
            },
            color: myEsimSecondaryBackGroundColor(context: context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: emptyStateWidget,
            ),
          )
        : Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    onRefresh?.call();
                  },
                  color: myEsimSecondaryBackGroundColor(context: context),
                  child: ListView.separated(
                    // shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: itemBuilder,
                    separatorBuilder: separatorBuilder ??
                        (BuildContext context, int index) =>
                            const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<T>("items", items))
      ..add(
        ObjectFlagProperty<IndexedWidgetBuilder>.has(
          "itemBuilder",
          itemBuilder,
        ),
      )
      ..add(
        ObjectFlagProperty<IndexedWidgetBuilder?>.has(
          "separatorBuilder",
          separatorBuilder,
        ),
      )
      ..add(ObjectFlagProperty<RefreshCallback?>.has("onRefresh", onRefresh));
  }
}

@AppPreview(name: "Empty State List View")
Widget emptyStateListViewPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: EmptyStateListView<String>(
        items: const <String>[],
        emptyStateWidget: const SizedBox(
          height: 200,
          child: Center(child: Text("No items to display")),
        ),
        itemBuilder: (BuildContext context, int index) =>
            const SizedBox.shrink(),
      ),
    ),
  );
}
