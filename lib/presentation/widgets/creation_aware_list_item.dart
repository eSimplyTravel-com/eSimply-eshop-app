import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class CreationAwareListItem extends StatefulWidget {
  const CreationAwareListItem({
    required this.child,
    super.key,
    this.itemCreated,
  });
  final Function? itemCreated;
  final Widget child;

  @override
  CreationAwareListItemState createState() => CreationAwareListItemState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Function?>("itemCreated", itemCreated));
  }
}

class CreationAwareListItemState extends State<CreationAwareListItem> {
  @override
  void initState() {
    super.initState();
    if (widget.itemCreated != null) {
      widget.itemCreated?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

@AppPreview(name: "Creation Aware List Item")
Widget creationAwareListItemPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: CreationAwareListItem(
        itemCreated: () {},
        child: const Text("Sample list item"),
      ),
    ),
  );
}
