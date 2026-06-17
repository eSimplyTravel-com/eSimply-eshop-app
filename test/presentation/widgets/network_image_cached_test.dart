import "dart:convert";
import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:esim_open_source/presentation/widgets/network_image_cached.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  // Real temp files so the true-local-file branches (SvgPicture.file,
  // Image.file, local gif) execute instead of the missing-file error path.
  late final Directory tempDir;
  late final File svgFile;
  late final File pngFile;
  late final File gifFile;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp("cached_image_test");
    svgFile = File("${tempDir.path}/image.svg");
    await svgFile.writeAsString(
      '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10"></svg>',
    );
    pngFile = File("${tempDir.path}/image.png");
    await pngFile.writeAsBytes(
      base64Decode(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4"
        "2mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==",
      ),
    );
    gifFile = File("${tempDir.path}/image.gif");
    await gifFile.writeAsBytes(
      base64Decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"),
    );
  });

  tearDownAll(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group("CachedImage Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    group("data holders", () {
      test("ImageDimensions defaults and values", () {
        // Arrange & Act
        const ImageDimensions d = ImageDimensions(width: 10, height: 20);

        // Assert
        expect(d.width, equals(10));
        expect(d.height, equals(20));
        expect(d.fit, equals(BoxFit.cover));
      });

      test("ImageWidgets holds widgets", () {
        // Arrange & Act
        const ImageWidgets w = ImageWidgets(
          placeholder: SizedBox(),
          errorWidget: Text("err"),
        );

        // Assert
        expect(w.placeholder, isA<SizedBox>());
        expect(w.errorWidget, isA<Text>());
      });

      test("ImageAnimations defaults", () {
        // Arrange & Act
        const ImageAnimations a = ImageAnimations();

        // Assert
        expect(a.fadeInDuration, equals(const Duration(milliseconds: 300)));
        expect(
          a.placeholderFadeInDuration,
          equals(const Duration(milliseconds: 300)),
        );
        expect(
            a.errorFadeInDuration, equals(const Duration(milliseconds: 300)));
      });
    });

    testWidgets("network non-svg renders CachedNetworkImage",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CachedImage.network(
              imagePath: "https://example.com/image.png",
              dimensions: const ImageDimensions(width: 100, height: 100),
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets("network gif renders CachedNetworkImage",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CachedImage.network(
              imagePath: "https://example.com/anim.gif",
              repeat: false,
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets("local asset svg renders SvgPicture with color filter",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CachedImage.local(
              imagePath: "assets/icons/sample.svg",
              svgColor: Colors.red,
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets("local asset image renders Image", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CachedImage.local(
              imagePath: "assets/images/sample.png",
              dimensions: const ImageDimensions(width: 50, height: 50),
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets("true local svg file renders SvgPicture",
        (WidgetTester tester) async {
      // Act
      await tester.runAsync(() async {
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: CachedImage.local(
                imagePath: svgFile.path,
                svgColor: Colors.blue,
              ),
            ),
          ),
        );
        await tester.pump();
      });
      tester.takeException();

      // Assert
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets("true local image file renders Image.file",
        (WidgetTester tester) async {
      // Act
      await tester.runAsync(() async {
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: CachedImage.local(
                imagePath: pngFile.path,
                dimensions: const ImageDimensions(width: 20, height: 20),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
      });
      tester.takeException();

      // Assert
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets("true local gif file renders Image.file",
        (WidgetTester tester) async {
      // Act
      await tester.runAsync(() async {
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: CachedImage.local(
                imagePath: gifFile.path,
                repeat: false,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
      });
      tester.takeException();

      // Assert
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets("local non-existent file shows error widget",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CachedImage.local(
              imagePath: "/non/existent/path/file.png",
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert — default error widget shown.
      expect(find.text("Image not available"), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets("local non-existent file uses custom error widget",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CachedImage.local(
              imagePath: "/non/existent/path/file.png",
              widgets: const ImageWidgets(
                errorWidget: Text("Custom error"),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Custom error"), findsOneWidget);
    });

    testWidgets("svg asset uses custom placeholder while loading",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CachedImage.local(
              imagePath: "assets/icons/sample.svg",
              widgets: const ImageWidgets(
                placeholder: Text("Loading svg"),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException();

      // Assert — placeholder builder renders the custom placeholder.
      expect(find.text("Loading svg"), findsOneWidget);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final CachedImage widget = CachedImage.network(
        imagePath: "https://example.com/x.png",
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "repeat",
        "imagePath",
        "source",
        "width",
        "height",
        "fit",
        "fadeInDuration",
        "placeholderFadeInDuration",
        "errorFadeInDuration",
        "svgColor",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    test("getters expose dimension and animation values", () {
      // Arrange & Act
      final CachedImage widget = CachedImage.network(
        imagePath: "https://example.com/x.png",
        dimensions:
            const ImageDimensions(width: 12, height: 34, fit: BoxFit.fill),
      );

      // Assert
      expect(widget.width, equals(12));
      expect(widget.height, equals(34));
      expect(widget.fit, equals(BoxFit.fill));
      expect(widget.source, equals(ImageSource.network));
      expect(
        widget.placeholderFadeInDuration,
        equals(const Duration(milliseconds: 300)),
      );
      expect(
        widget.errorFadeInDuration,
        equals(const Duration(milliseconds: 300)),
      );
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(cachedImagePreview()),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(CachedImage), findsOneWidget);
    });
  });
}
