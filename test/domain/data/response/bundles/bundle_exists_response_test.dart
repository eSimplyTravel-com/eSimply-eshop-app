import "package:esim_open_source/domain/data/response/bundles/bundle_exists_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleExistsResponse
void main() {
  group("BundleExistsResponse Tests", () {
    test("constructor assigns values correctly", () {
      // Act
      final BundleExistsResponse response = BundleExistsResponse(exists: true);

      // Assert
      expect(response.exists, true);
    });

    test("constructor with false value", () {
      // Act
      final BundleExistsResponse response = BundleExistsResponse(exists: false);

      // Assert
      expect(response.exists, false);
    });

    test("constructor with null exists", () {
      // Act
      final BundleExistsResponse response = BundleExistsResponse(exists: null);

      // Assert
      expect(response.exists, isNull);
    });

    test("default constructor creates null exists", () {
      // Act
      final BundleExistsResponse response = BundleExistsResponse();

      // Assert
      expect(response.exists, isNull);
    });

    test("multiple instances are independent", () {
      // Act
      final BundleExistsResponse response1 = BundleExistsResponse(exists: true);
      final BundleExistsResponse response2 = BundleExistsResponse(exists: false);

      // Assert
      expect(response1.exists, true);
      expect(response2.exists, false);
    });


    test("response type is correct", () {
      // Act
      final BundleExistsResponse response = BundleExistsResponse();

      // Assert
      expect(response, isA<BundleExistsResponse>());
    });
  });
}
