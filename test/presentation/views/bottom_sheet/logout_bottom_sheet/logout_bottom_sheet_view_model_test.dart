import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/logout_bottom_sheet/logout_bottom_sheet_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late LogoutBottomSheetViewModel viewModel;
  late MockApiAuthRepository mockApiAuthRepository;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "LogoutBottomSheet");
    viewModel = LogoutBottomSheetViewModel();
    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("LogoutBottomSheetViewModel Tests", () {
    test("logoutButtonTapped executes successfully with success response",
        () async {
      // Arrange
      when(mockApiAuthRepository.logout()).thenAnswer(
        (_) async => Resource<EmptyResponse>.success(
          EmptyResponse(),
          message: "Success",
        ),
      );

      // Act
      await viewModel.logoutButtonTapped();

      // Assert
      verify(mockApiAuthRepository.logout()).called(1);
    });

    test("logoutButtonTapped handles error response", () async {
      // Arrange
      when(mockApiAuthRepository.logout()).thenAnswer(
        (_) async => Resource<EmptyResponse>.error(
          "Logout failed",
        ),
      );

      // Act
      await viewModel.logoutButtonTapped();

      // Assert
      verify(mockApiAuthRepository.logout()).called(1);
    });
  });
}
