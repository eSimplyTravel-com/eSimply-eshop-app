import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("StoryItem Tests", () {
    test("holds provided values", () {
      // Arrange & Act
      final StoryItem item = StoryItem(
        content: const Text("content"),
        buttons: const Text("buttons"),
        duration: const Duration(seconds: 5),
      );

      // Assert
      expect(item.content, isA<Text>());
      expect(item.buttons, isA<Text>());
      expect(item.duration, equals(const Duration(seconds: 5)));
      expect(item.useSplitTransition, isFalse);
    });

    test("useSplitTransition can be set", () {
      // Arrange & Act
      final StoryItem item = StoryItem(
        content: const SizedBox(),
        buttons: const SizedBox(),
        duration: const Duration(seconds: 3),
        useSplitTransition: true,
      );

      // Assert
      expect(item.useSplitTransition, isTrue);
    });
  });

  group("StoryViewerArgs Tests", () {
    test("applies default values", () {
      // Arrange & Act
      final StoryViewerArgs args = StoryViewerArgs(
        stories: <StoryItem>[],
      );

      // Assert
      expect(args.autoClose, isTrue);
      expect(args.onComplete, isNull);
      expect(args.indicatorHeight, equals(6));
      expect(args.indicatorBorderRadius, equals(16));
      expect(args.indicatorColor, equals(Colors.white));
      expect(args.indicatorBackgroundColor, equals(Colors.white30));
      expect(args.stories, isEmpty);
    });

    test("accepts custom values", () {
      // Arrange
      bool completed = false;
      final StoryItem item = StoryItem(
        content: const SizedBox(),
        buttons: const SizedBox(),
        duration: const Duration(seconds: 2),
      );

      // Act
      final StoryViewerArgs args = StoryViewerArgs(
        stories: <StoryItem>[item],
        onComplete: () => completed = true,
        autoClose: false,
        indicatorHeight: 10,
        indicatorBorderRadius: 8,
        indicatorColor: Colors.red,
        indicatorBackgroundColor: Colors.black,
      );
      args.onComplete?.call();

      // Assert
      expect(args.autoClose, isFalse);
      expect(args.stories.length, equals(1));
      expect(args.indicatorHeight, equals(10));
      expect(args.indicatorBorderRadius, equals(8));
      expect(args.indicatorColor, equals(Colors.red));
      expect(args.indicatorBackgroundColor, equals(Colors.black));
      expect(completed, isTrue);
    });
  });
}
