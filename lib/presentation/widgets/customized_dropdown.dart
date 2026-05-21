import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MyDropDown extends StatelessWidget {
  const MyDropDown({
    required this.valueList,
    required this.onChanged,
    super.key,
    this.selectedValueIndex = -1,
    this.cupertinoSheetTitle,
    this.triggerActionSheet = false,
    this.emptyWidget,
    this.isExpanded = false,
    this.underline,
  });
  final List<String> valueList;
  final int selectedValueIndex;
  final String? cupertinoSheetTitle;
  final Widget? emptyWidget;
  final bool isExpanded;
  final void Function(int, String?) onChanged;
  final bool triggerActionSheet;
  final Widget? underline;

  bool get _hasValidSelection =>
      selectedValueIndex >= 0 && valueList.length > selectedValueIndex;

  String get _selectedValue => _hasValidSelection ? valueList[selectedValueIndex] : "";

  String? get _selectedValueOrNull => _hasValidSelection ? valueList[selectedValueIndex] : null;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          if (triggerActionSheet) {
            await triggerActionSheetCall(context);
          }
        },
      );

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async => <Future<void>>{triggerActionSheetCall(context)},
        child: _hasValidSelection
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _selectedValue,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .cForeground(context),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 28,
                              color: Theme.of(context)
                                  .colorScheme
                                  .cForeground(context),
                            ),
                          ],
                        ),
                        underline ??
                            Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .cHintTextColor(context)
                                  .withAlpha(80),
                            ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            emptyWidget ?? Container(),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 28,
                              color: Theme.of(context)
                                  .colorScheme
                                  .cForeground(context),
                            ),
                          ],
                        ),
                        underline ??
                            Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .cHintTextColor(context)
                                  .withAlpha(80),
                            ),
                      ],
                    ),
                  ),
      );
    } else {
      return DropdownButton<String>(
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
        dropdownColor: Theme.of(context).colorScheme.cBackground(context),
        iconEnabledColor: Theme.of(context).colorScheme.cForeground(context),
        value: _selectedValueOrNull,
        items: valueList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.cForeground(context),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? userSelectedVal) => <void>{
          onChanged(
            valueList.indexOf(userSelectedVal ?? ""),
            userSelectedVal,
          ),
        },
      );
    }
  }

  Future<void> triggerActionSheetCall(BuildContext context) =>
      showActionSheet(context).then(
        (dynamic userSelectedVal) => onChanged(
          valueList.indexOf(userSelectedVal ?? ""),
          userSelectedVal,
        ),
      );

  Future<void> showActionSheet(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: cupertinoSheetTitle != null
            ? Text(
                cupertinoSheetTitle!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.cPrimaryColor(context),
                ),
              )
            : null,
        actions: valueList.map((String value) {
          return CupertinoActionSheetAction(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.cPrimaryColor(context),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, value);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            LocaleKeys.cancel.tr(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.cPrimaryColor(context),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<String>("valueList", valueList))
      ..add(IntProperty("selectedValueIndex", selectedValueIndex))
      ..add(StringProperty("cupertinoSheetTitle", cupertinoSheetTitle))
      ..add(DiagnosticsProperty<bool>("isExpanded", isExpanded))
      ..add(
        ObjectFlagProperty<void Function(int p1, String? p2)>.has(
          "onChanged",
          onChanged,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>("triggerActionSheet", triggerActionSheet),
      );
  }
}

@AppPreview(name: "Customized Dropdown")
Widget myDropDownPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: MyDropDown(
        valueList: const <String>["Option A", "Option B", "Option C"],
        selectedValueIndex: 0,
        isExpanded: true,
        onChanged: (int index, String? value) {},
      ),
    ),
  );
}
