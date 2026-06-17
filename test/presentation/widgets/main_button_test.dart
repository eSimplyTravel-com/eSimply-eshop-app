import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("MainButton Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders title", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MainButton(
              title: "Submit",
              onPressed: () {},
              themeColor: Colors.blue,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.text("Submit"), findsOneWidget);
    });

    testWidgets("invokes onPressed when enabled and tapped",
        (WidgetTester tester) async {
      // Arrange
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MainButton(
              title: "Tap",
              onPressed: () => pressed = true,
              themeColor: Colors.blue,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(MainButton));
      await tester.pump();

      // Assert
      expect(pressed, isTrue);
    });

    testWidgets("does not invoke onPressed when disabled",
        (WidgetTester tester) async {
      // Arrange
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MainButton(
              title: "Disabled",
              onPressed: () => pressed = true,
              themeColor: Colors.blue,
              isEnabled: false,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(MainButton));
      await tester.pump();

      // Assert
      expect(pressed, isFalse);
    });

    testWidgets("renders leading and trailing widgets",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MainButton(
              title: "Both",
              onPressed: () {},
              themeColor: Colors.blue,
              leadingWidget: const Icon(Icons.star, key: Key("lead")),
              trailingWidget:
                  const Icon(Icons.arrow_forward, key: Key("trail")),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(const Key("lead")), findsOneWidget);
      expect(find.byKey(const Key("trail")), findsOneWidget);
    });

    testWidgets("renders with shadows when hideShadows is false",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MainButton(
              title: "Shadow",
              onPressed: () {},
              themeColor: Colors.blue,
              borderColor: Colors.red,
            ),
          ),
        ),
      );

      // Assert — builds with border + default (shown) shadows.
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets("applies custom titleTextStyle", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MainButton(
              title: "Styled",
              onPressed: () {},
              themeColor: Colors.blue,
              titleTextStyle: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      );

      // Assert
      final Text textWidget = tester.widget<Text>(find.text("Styled"));
      expect(textWidget.style?.fontSize, equals(24));
    });

    group("factory constructors", () {
      MainButtonParams params({bool isEnabled = true}) => MainButtonParams(
            title: "Factory",
            onPressed: () {},
            themeColor: Colors.green,
            isEnabled: isEnabled,
          );

      testWidgets("onlyText builds a MainButton", (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(body: MainButton.onlyText(params: params())),
          ),
        );

        // Assert
        expect(find.byType(MainButton), findsOneWidget);
        expect(find.text("Factory"), findsOneWidget);
      });

      testWidgets("emptyBackground builds a MainButton",
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(body: MainButton.emptyBackground(params: params())),
          ),
        );

        // Assert
        expect(find.byType(MainButton), findsOneWidget);
        expect(find.text("Factory"), findsOneWidget);
      });

      testWidgets("continueWith builds a MainButton with leading image",
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MainButton.continueWith(
                params: params(),
                action: () {},
                buttonColor: Colors.white,
                textColor: Colors.black,
                image: "assets/images/sample.png",
              ),
            ),
          ),
        );
        tester.takeException(); // consume asset-load failure for the image

        // Assert
        expect(find.byType(MainButton), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets("bannerButton builds a MainButton",
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MainButton.bannerButton(
                params: BannerButtonParams(
                  title: "Banner",
                  action: () {},
                  themeColor: Colors.green,
                  textColor: Colors.white,
                  buttonColor: Colors.green,
                  titleTextStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(MainButton), findsOneWidget);
        expect(find.text("Banner"), findsOneWidget);
      });

      test("MainButtonParams holds values", () {
        // Arrange & Act
        final MainButtonParams p = params(isEnabled: false);

        // Assert
        expect(p.title, equals("Factory"));
        expect(p.isEnabled, isFalse);
        expect(p.themeColor, equals(Colors.green));
      });

      test("BannerButtonParams holds values", () {
        // Arrange & Act
        final BannerButtonParams p = BannerButtonParams(
          title: "B",
          action: () {},
          themeColor: Colors.green,
          textColor: Colors.white,
          buttonColor: Colors.blue,
          titleTextStyle: const TextStyle(fontSize: 10),
        );

        // Assert
        expect(p.title, equals("B"));
        expect(p.height, equals(38));
        expect(p.hideShadows, isTrue);
      });
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final MainButton widget = MainButton(
        title: "t",
        onPressed: () {},
        themeColor: Colors.blue,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "title",
        "isEnabled",
        "onPressed",
        "width",
        "height",
        "enabledBackgroundColor",
        "disabledBackgroundColor",
        "enabledTextColor",
        "disabledTextColor",
        "titleTextStyle",
        "borderRadius",
        "themeColor",
        "borderColor",
        "containerPadding",
        "hideShadows",
        "textAlignment",
        "verticalPadding",
        "horizontalPadding",
        "rowMainAxisSize",
        "titleHorizontalPadding",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(mainButtonPreview()),
      );

      // Assert
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.text("Continue"), findsOneWidget);
    });
  });
}
