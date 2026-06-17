import "package:adaptive_platform_ui/adaptive_platform_ui.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BaseAdaptiveBottomNavBar extends StatefulWidget {
  const BaseAdaptiveBottomNavBar({
    required this.tabsIconData,
    required this.tabsWidgets,
    required this.tabsText,
    super.key,
    this.isKeyboardVisible = false,
    this.tabController,
    this.floatingActionButton,
    this.backgroundColor,
  });

  final List<String> tabsIconData;
  final List<String> tabsText;
  final List<Widget> tabsWidgets;
  final bool isKeyboardVisible;
  final LockableTabController? tabController;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  @override
  State<BaseAdaptiveBottomNavBar> createState() =>
      _BaseAdaptiveBottomNavBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<String>("tabsIconData", tabsIconData))
      ..add(IterableProperty<String>("tabsText", tabsText))
      ..add(DiagnosticsProperty<bool>("isKeyboardVisible", isKeyboardVisible))
      ..add(
        DiagnosticsProperty<TabController?>("tabController", tabController),
      )
      ..add(ColorProperty("backgroundColor", backgroundColor));
  }
}

class _BaseAdaptiveBottomNavBarState extends State<BaseAdaptiveBottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tabController?.index ?? 0;
    widget.tabController?.addListener(_syncFromController);
  }

  void _syncFromController() {
    final int idx = widget.tabController?.index ?? _currentIndex;
    if (idx != _currentIndex && mounted) {
      setState(() => _currentIndex = idx);
    }
  }

  @override
  void didUpdateWidget(covariant BaseAdaptiveBottomNavBar oldWidget) {
    if (oldWidget.tabController != widget.tabController) {
      oldWidget.tabController?.removeListener(_syncFromController);
      widget.tabController?.addListener(_syncFromController);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.tabController?.removeListener(_syncFromController);
    super.dispose();
  }

  void _onTap(int index) {
    if (widget.tabController?.isLocked ?? false) {
      return;
    }
    widget.tabController?.animateTo(index);
    setState(() => _currentIndex = index);
  }

  String _getTabLabel(int index) {
    return widget.tabsText.length > index ? widget.tabsText[index] : "";
  }

  @override
  Widget build(BuildContext context) {
    final int clampedIndex = _currentIndex.clamp(
      0,
      widget.tabsWidgets.length - 1,
    );

    final Widget body = IndexedStack(
      index: clampedIndex,
      children: widget.tabsWidgets,
    );

    return AdaptiveScaffold(
      minimizeBehavior: TabBarMinimizeBehavior.never,
      floatingActionButton: widget.floatingActionButton,
      body: widget.backgroundColor == null
          ? body
          : ColoredBox(color: widget.backgroundColor!, child: body),
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        selectedIndex: clampedIndex,
        onTap: _onTap,
        items: <AdaptiveNavigationDestination>[
          for (int i = 0; i < widget.tabsIconData.length; i++)
            AdaptiveNavigationDestination(
              icon: widget.tabsIconData[i],
              label: _getTabLabel(i),
            ),
        ],
      ),
    );
  }
}

@AppPreview(name: "Bottom Navigation Bar")
Widget baseAdaptiveBottomNavBarPreview() {
  return const BaseAdaptiveBottomNavBar(
    tabsIconData: <String>["home", "settings", "profile"],
    tabsText: <String>["Home", "Settings", "Profile"],
    tabsWidgets: <Widget>[
      Center(child: Text("Home")),
      Center(child: Text("Settings")),
      Center(child: Text("Profile")),
    ],
  );
}
