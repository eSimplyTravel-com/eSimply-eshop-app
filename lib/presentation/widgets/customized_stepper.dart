import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MyStepper extends StatefulWidget {
  const MyStepper({
    required this.tabsWidgets,
    required this.themeColor,
    super.key,
    this.tabController,
    this.initialValue = 0,
  });
  // final List<String> tabsTitle;
  final List<Widget> tabsWidgets;
  final Color themeColor;
  final TabController? tabController;

  final int initialValue;
  @override
  State<MyStepper> createState() => _MyStepperState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty("themeColor", themeColor))
      ..add(DiagnosticsProperty<TabController?>("tabController", tabController))
      ..add(IntProperty("initialValue", initialValue));
  }
}

class _MyStepperState extends State<MyStepper> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialValue;
    widget.tabController?.addListener(() {
      setState(() {
        _currentIndex = widget.tabController?.index ?? _currentIndex;
      });
      // log("Selected Index: ${widget.tabController?.index}");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // log("Selected  build Index: ${widget.tabController?.index}   build initialValue: ${widget.initialValue}");
    return DefaultTabController(
      length: widget.tabsWidgets.length,
      child: Column(
        children: <Widget>[
          ColoredBox(
            color: widget.themeColor,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TabBar(
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          enableFeedback: false,
                          controller: widget.tabController,
                          onTap: (int index) {
                            // setState(() {
                            //   _currentIndex = index;
                            // });
                          },
                          // indicatorColor: widget.themeColor,
                          indicatorWeight: 0.1,
                          indicatorColor: Colors.transparent,
                          tabs: generateTabs(
                            selectedIndex: _currentIndex,
                            tabsWidgets: widget.tabsWidgets,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.zero,
              height: double.infinity,
              width: double.infinity,
              child: TabBarView(
                controller: widget.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.tabsWidgets,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generateTabs({
    required List<Widget> tabsWidgets,
    required int selectedIndex,
  }) {
    // log("generateTabs");
    return tabsWidgets
        .mapIndexed(
          (Widget title, int index) => Tab(
            height: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: index <= selectedIndex
                      ? Theme.of(context).colorScheme.cPrimaryColor(context)
                      : Theme.of(context)
                          .colorScheme
                          .cHintTextColor(context)
                          .withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}

@AppPreview(name: "My Stepper")
Widget myStepperPreview() {
  return const Scaffold(
    body: MyStepper(
      themeColor: Colors.blue,
      initialValue: 1,
      tabsWidgets: <Widget>[
        Center(child: Text("Step 1")),
        Center(child: Text("Step 2")),
        Center(child: Text("Step 3")),
      ],
    ),
  );
}
