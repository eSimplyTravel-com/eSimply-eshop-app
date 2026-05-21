import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ExpansionList<T> extends StatefulWidget {
  const ExpansionList({
    required this.items,
    required this.onItemSelected,
    super.key,
    this.title,
    this.smallVersion = false,
  });
  final List<T> items;
  final String? title;
  final Function(dynamic) onItemSelected;
  final bool smallVersion;

  @override
  ExpansionListState createState() => ExpansionListState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<T>("items", items))
      ..add(StringProperty("title", title))
      ..add(
        ObjectFlagProperty<Function(dynamic p1)>.has(
          "onItemSelected",
          onItemSelected,
        ),
      )
      ..add(DiagnosticsProperty<bool>("smallVersion", smallVersion));
  }
}

class ExpansionListState extends State<ExpansionList<dynamic>> {
  final double startingHeight = 55;
  double? expandedHeight;
  bool expanded = false;
  String? selectedValue;

  double get collapsedHeight => widget.smallVersion ? 40 : startingHeight;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.title;
    _calculateExpandedHeight();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      duration: const Duration(milliseconds: 180),
      height: expanded ? expandedHeight : collapsedHeight,
      decoration: fieldDecoration.copyWith(
        boxShadow: expanded
            ? <BoxShadow>[
                BoxShadow(blurRadius: 10, color: Colors.grey.shade300),
              ]
            : null,
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          ExpansionListItem(
            title: selectedValue ?? "",
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            showArrow: true,
            smallVersion: widget.smallVersion,
          ),
          Container(
            height: 2,
            color: Colors.grey[300],
          ),
          ..._getDropdownListItems(),
        ],
      ),
    );
  }

  List<Widget> _getDropdownListItems() {
    return widget.items
        .map(
          (dynamic item) => ExpansionListItem(
            smallVersion: widget.smallVersion,
            title: item.toString(),
            onTap: () {
              setState(() {
                expanded = !expanded;
                selectedValue = item.toString();
              });

              widget.onItemSelected(item);
            },
          ),
        )
        .toList();
  }

  void _calculateExpandedHeight() {
    expandedHeight = 2 +
        (widget.smallVersion ? 40 : 55) +
        (widget.items.length * (widget.smallVersion ? 40 : 55));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("startingHeight", startingHeight))
      ..add(DoubleProperty("expandedHeight", expandedHeight))
      ..add(DiagnosticsProperty<bool>("expanded", expanded))
      ..add(StringProperty("selectedValue", selectedValue))
      ..add(DoubleProperty("collapsedHeight", collapsedHeight));
  }
}

class ExpansionListItem extends StatelessWidget {
  const ExpansionListItem({
    required this.onTap,
    super.key,
    this.title,
    this.showArrow = false,
    this.smallVersion = false,
  });
  final void Function() onTap;
  final String? title;
  final bool showArrow;
  final bool smallVersion;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: smallVersion ? 40 : 55,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                title ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: smallVersion ? 12 : 15),
              ),
            ),
            showArrow
                ? Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[700],
                    size: 20,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<void Function()>.has("onTap", onTap))
      ..add(StringProperty("title", title))
      ..add(DiagnosticsProperty<bool>("showArrow", showArrow))
      ..add(DiagnosticsProperty<bool>("smallVersion", smallVersion));
  }
}

@AppPreview(name: "Expansion List")
Widget expansionListPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: ExpansionList<String>(
        title: "Select an option",
        items: const <String>["Option 1", "Option 2", "Option 3"],
        onItemSelected: (_) {},
      ),
    ),
  );
}
