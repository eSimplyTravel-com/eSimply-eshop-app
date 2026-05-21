import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

enum ChildWidgetTabState {
  show,
  hidden,
  showWithAnimation;
}

class DataPlansTabView extends StatefulWidget {
  const DataPlansTabView({
    required this.tabs,
    required this.tabViewsChildren,
    super.key,
    this.height = 45,
    this.borderRadius = 12,
    this.backGroundColor = Colors.transparent,
    this.selectedTabColor,
    this.unSelectedTabColor,
    this.selectedLabelColor,
    this.unSelectedLabelColor,
    this.childWidget,
    this.isScrollable = false,
    this.verticalPadding = 0,
    this.horizontalPadding = 15,
    this.tabsSpacing = 5,
    this.initialIndex = 0,
    this.onTabChange,
    this.isIndicatorUnderlined = false,
    this.selectedTabTextStyle,
    this.unSelectedTabTextStyle,
    this.isChildCollapsable = false,
  });

  final List<Tab> tabs;
  final List<Widget> tabViewsChildren;
  final double height;
  final double borderRadius;
  final Color backGroundColor;
  final Color? selectedTabColor;
  final Color? unSelectedTabColor;
  final Color? selectedLabelColor;
  final Color? unSelectedLabelColor;
  final Widget? childWidget;
  final bool isScrollable;
  final double verticalPadding;
  final double horizontalPadding;
  final double tabsSpacing;
  final int initialIndex;
  final bool isIndicatorUnderlined;
  final void Function(int newIndex)? onTabChange;
  final TextStyle? selectedTabTextStyle;
  final TextStyle? unSelectedTabTextStyle;
  final bool isChildCollapsable;

  @override
  State<DataPlansTabView> createState() => _DataPlansTabViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("height", height))
      ..add(DoubleProperty("borderRadius", borderRadius))
      ..add(ColorProperty("backGroundColor", backGroundColor))
      ..add(ColorProperty("selectedTabColor", selectedTabColor))
      ..add(ColorProperty("unSelectedTabColor", unSelectedTabColor))
      ..add(ColorProperty("selectedLabelColor", selectedLabelColor))
      ..add(ColorProperty("unSelectedLabelColor", unSelectedLabelColor))
      ..add(DiagnosticsProperty<bool>("isScrollable", isScrollable))
      ..add(DoubleProperty("horizontalPadding", horizontalPadding))
      ..add(DoubleProperty("tabsSpacing", tabsSpacing))
      ..add(DoubleProperty("verticalPadding", verticalPadding))
      ..add(IntProperty("initialIndex", initialIndex))
      ..add(
        ObjectFlagProperty<void Function(int newIndex)?>.has(
          "onTabChange",
          onTabChange,
        ),
      )
      ..add(
        DiagnosticsProperty<bool?>(
          "isIndicatorUnderlined",
          isIndicatorUnderlined,
        ),
      )
      ..add(
        DiagnosticsProperty<TextStyle?>(
          "unSelectedTabTextStyle",
          unSelectedTabTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty<TextStyle?>(
          "selectedTabTextStyle",
          selectedTabTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>(
          "isChildCollapsable",
          isChildCollapsable,
        ),
      );
  }
}

class _DataPlansTabViewState extends State<DataPlansTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ChildWidgetTabState childWidgetTabState = ChildWidgetTabState.show;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initScrollListener();
    _tabController = TabController(
      initialIndex: widget.initialIndex,
      length: widget.tabs.length,
      vsync: this,
    );
    _tabController.addListener(tabBarSelectionChanged);
  }

  @override
  void didUpdateWidget(covariant DataPlansTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      childWidgetTabState = ChildWidgetTabState.show;
    });

    _tabController.animateTo(widget.initialIndex);
  }

  void initScrollListener() {
    if (widget.isChildCollapsable) {
      scrollController.addListener(() {
        if (scrollController.offset > 50 &&
            childWidgetTabState != ChildWidgetTabState.hidden) {
          setState(() {
            childWidgetTabState = ChildWidgetTabState.hidden;
          });
        } else if (scrollController.offset <= 50 &&
            childWidgetTabState == ChildWidgetTabState.hidden) {
          setState(() {
            childWidgetTabState = ChildWidgetTabState.showWithAnimation;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void tabBarSelectionChanged() {
    playHapticFeedback(HapticFeedbackType.pagerSelectionChange);
    widget.onTabChange?.call(_tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ColoredBox(
        color: widget.backGroundColor,
        child: PaddingWidget.applyPadding(
          top: widget.verticalPadding,
          child: Column(
            children: <Widget>[
              _buildTabBar(context),
              _buildChildWidget(),
              _buildTabBarView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return PaddingWidget.applySymmetricPadding(
      horizontal: widget.horizontalPadding,
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: <Widget>[
            TabBar(
              controller: _tabController,
              indicatorPadding: const EdgeInsets.only(bottom: 2),
              indicator: _buildTabIndicator(context),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: widget.selectedTabColor,
              labelColor: widget.selectedLabelColor ??
                  mainWhiteTextColor(context: context),
              unselectedLabelColor: widget.unSelectedLabelColor ??
                  mainDarkTextColor(context: context),
              labelStyle: widget.selectedTabTextStyle ??
                  captionOneBoldTextStyle(context: context),
              unselectedLabelStyle: widget.unSelectedTabTextStyle ??
                  captionOneNormalTextStyle(context: context),
              tabs: widget.tabs,
            ),
            _buildTabBorderOverlay(),
          ],
        ),
      ),
    );
  }

  Decoration? _buildTabIndicator(BuildContext context) {
    if (widget.isIndicatorUnderlined) {
      return null;
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      color: widget.selectedTabColor ?? mainTabBackGroundColor(context: context),
    );
  }

  Widget _buildTabBorderOverlay() {
    return IgnorePointer(
      child: Transform.translate(
        offset: const Offset(0, 1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.backGroundColor,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildWidget() {
    if (widget.isChildCollapsable) {
      return _buildCollapsableChildWidget();
    }
    return widget.childWidget ?? const SizedBox.shrink();
  }

  Widget _buildCollapsableChildWidget() {
    final Duration animationDuration = _getAnimationDuration();
    final double heightFactor = _getHeightFactor();
    final double containerHeight = _getContainerHeight();

    return ClipRect(
      child: AnimatedAlign(
        alignment: Alignment.topCenter,
        duration: animationDuration,
        heightFactor: heightFactor,
        child: AnimatedContainer(
          duration: animationDuration,
          height: containerHeight,
          child: widget.childWidget ?? const SizedBox.shrink(),
        ),
      ),
    );
  }

  Duration _getAnimationDuration() {
    return childWidgetTabState == ChildWidgetTabState.show
        ? Duration.zero
        : const Duration(milliseconds: 400);
  }

  double _getHeightFactor() {
    return childWidgetTabState == ChildWidgetTabState.hidden ? 0 : 1;
  }

  double _getContainerHeight() {
    if (childWidgetTabState == ChildWidgetTabState.hidden) {
      return 0;
    }
    if (widget.childWidget == null) {
      return 0;
    }
    return 200;
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: PaddingWidget.applySymmetricPadding(
        horizontal: widget.horizontalPadding,
        child: TabBarView(
          controller: _tabController,
          physics: widget.isScrollable
              ? null
              : const NeverScrollableScrollPhysics(),
          children: _buildTabViewChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildTabViewChildren() {
    if (widget.isChildCollapsable) {
      return _buildCollapsableTabViewChildren();
    }
    return _buildCenteredTabViewChildren();
  }

  List<Widget> _buildCollapsableTabViewChildren() {
    return widget.tabViewsChildren
        .map(_wrapWithScrollListener)
        .toList();
  }

  List<Widget> _buildCenteredTabViewChildren() {
    return widget.tabViewsChildren
        .map((Widget child) => Center(child: child))
        .toList();
  }

  Widget _wrapWithScrollListener(Widget child) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: child,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      _updateChildWidgetStateBasedOnScroll(notification.metrics.pixels);
    }
    return false;
  }

  void _updateChildWidgetStateBasedOnScroll(double offset) {
    if (_shouldHideChildWidget(offset)) {
      setState(() {
        childWidgetTabState = ChildWidgetTabState.hidden;
      });
    } else if (_shouldShowChildWidget(offset)) {
      setState(() {
        childWidgetTabState = ChildWidgetTabState.showWithAnimation;
      });
    }
  }

  bool _shouldHideChildWidget(double offset) {
    return offset > 50 && childWidgetTabState != ChildWidgetTabState.hidden;
  }

  bool _shouldShowChildWidget(double offset) {
    return offset <= 50 && childWidgetTabState == ChildWidgetTabState.hidden;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        EnumProperty<ChildWidgetTabState>(
          "childWidgetTabState",
          childWidgetTabState,
        ),
      )
      ..add(
        DiagnosticsProperty<ScrollController>(
          "scrollController",
          scrollController,
        ),
      );
  }
}

@AppPreview(name: "Data Plans Tab View")
Widget dataPlansTabViewPreview() {
  return const Scaffold(
    body: Column(
      children: <Widget>[
        DataPlansTabView(
          tabs: <Tab>[
            Tab(text: "Local"),
            Tab(text: "Regional"),
            Tab(text: "Global"),
          ],
          tabViewsChildren: <Widget>[
            Text("Local plans"),
            Text("Regional plans"),
            Text("Global plans"),
          ],
        ),
      ],
    ),
  );
}
