import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_sections.dart";

class MyWalletViewModel extends BaseModel {
  List<MyWalletViewSections> walletSections = MyWalletViewSections.values;

  GetUserInfoUseCase getUserInfoUseCase =
      GetUserInfoUseCase(locator<ApiAuthRepository>());

  @override
  Future<void> onViewModelReady() async {
    refreshUserInfo();
  }

  Future<void> refreshUserInfo() async {
    applyShimmer = true;
    Resource<AuthResponseModel?> response =
        await getUserInfoUseCase.execute(NoParams());

    handleResponse(
      response,
      onSuccess: (Resource<AuthResponseModel?> result) async {},
    );

    applyShimmer = false;
    notifyListeners();
  }
}
