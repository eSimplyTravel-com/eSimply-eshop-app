import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MyGenericDropDown<T> extends StatelessWidget {
  const MyGenericDropDown({
    required this.valueList,
    required this.onChanged,
    required this.buildItem,
    super.key,
    this.selectedValueIndex = -1,
    this.emptyWidget,
    this.isExpanded = false,
    this.underline,
    this.itemHeight,
    this.dropdownColor,
  });
  final List<T> valueList;
  final int selectedValueIndex;
  final Widget? emptyWidget;
  final bool isExpanded;
  final Color? dropdownColor;
  final double? itemHeight;
  final void Function(int, T?) onChanged;
  final Widget Function(BuildContext, T?) buildItem;
  final Widget? underline;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      dropdownColor:
          dropdownColor ?? Theme.of(context).colorScheme.cBackground(context),
      itemHeight: itemHeight,
      underline: underline ??
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: Theme.of(context)
                .colorScheme
                .cHintTextColor(context)
                .withAlpha(80),
          ),
      isExpanded: isExpanded,
      hint: emptyWidget,
      iconEnabledColor: Theme.of(context).colorScheme.cForeground(context),
      value: (selectedValueIndex >= 0 && valueList.length > selectedValueIndex)
          ? valueList[selectedValueIndex]
          : null,
      items: valueList.map((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: buildItem(context, value),
        );
      }).toList(),
      onChanged: (dynamic userSelectedVal) => <void>{
        onChanged(
          userSelectedVal != null ? valueList.indexOf(userSelectedVal) : -1,
          userSelectedVal,
        ),
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<T>("valueList", valueList))
      ..add(IntProperty("selectedValueIndex", selectedValueIndex))
      ..add(DiagnosticsProperty<bool>("isExpanded", isExpanded))
      ..add(ColorProperty("dropdownColor", dropdownColor))
      ..add(DoubleProperty("itemHeight", itemHeight))
      ..add(
        ObjectFlagProperty<void Function(int p1, T? p2)>.has(
          "onChanged",
          onChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<Widget Function(BuildContext p1, T? p2)>.has(
          "buildItem",
          buildItem,
        ),
      );
  }
}

@AppPreview(name: "Customized Generic Dropdown")
Widget myGenericDropDownPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: MyGenericDropDown<String>(
        valueList: const <String>["Apple", "Banana", "Cherry"],
        selectedValueIndex: 0,
        isExpanded: true,
        onChanged: (int index, String? value) {},
        buildItem: (BuildContext context, String? value) =>
            Text(value ?? ""),
      ),
    ),
  );
}
