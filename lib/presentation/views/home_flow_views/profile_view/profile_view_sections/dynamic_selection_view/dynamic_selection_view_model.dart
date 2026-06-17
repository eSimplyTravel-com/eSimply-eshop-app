import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_currencies_use_case.dart";
import "package:esim_open_source/domain/use_case/auth/update_user_info_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/language_enum.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/generation_helper.dart";
import "package:esim_open_source/utils/language_currency_helper.dart";
import "package:stacked_services/stacked_services.dart";

abstract class DynamicSelectionViewDataSource {
  String get viewTitle;

  List<String> get data;

  set data(List<String> newData);

  String get dialogTitleText;

  String get dialogContentText;

  String get selectedData;

  bool isSelected(int index);

  Future<List<String>> getSelections();

  Future<void> setNewSelection(String code);

  DynamicSelectionViewModel? viewModel;
}

class CurrenciesDataSource implements DynamicSelectionViewDataSource {
  List<String> _data = <String>[];

  @override
  String get viewTitle => LocaleKeys.profile_currency.tr();

  @override
  List<String> get data => _data;

  @override
  set data(List<String> newData) {
    _data = newData;
  }

  @override
  String get selectedData => getSelectedCurrencyCode();

  @override
  String get dialogTitleText => LocaleKeys.confirmation_currencyTitle.tr();

  @override
  String get dialogContentText => LocaleKeys.confirmation_currencyContent.tr();

  @override
  Future<List<String>> getSelections() async {
    GetCurrenciesUseCase getCurrenciesUseCase =
        GetCurrenciesUseCase(locator<ApiAppRepository>());

    Resource<List<CurrenciesResponseModel>?> response =
        await getCurrenciesUseCase.execute(NoParams());

    List<String> result = response.data
            ?.map((CurrenciesResponseModel e) => e.currency ?? "")
            .where((String item) => item.trim().isNotEmpty)
            .toList() ??
        <String>[];

    return result;
  }

  @override
  Future<void> setNewSelection(String code) async {
    if (viewModel?.isUserLoggedIn ?? false) {
      await viewModel?.updateLanguageAndCurrencyCode(currencyCode: code);
    } else {
      await syncLanguageAndCurrencyCode(
        currencyCode: code,
      );
    }
  }

  @override
  bool isSelected(int index) {
    String value = _data[index];
    return value == selectedData;
  }

  @override
  DynamicSelectionViewModel? viewModel;
}

class LanguagesDataSource implements DynamicSelectionViewDataSource {
  List<String> _data = <String>[];

  @override
  String get viewTitle => LocaleKeys.profile_language.tr();

  @override
  List<String> get data => _data;

  @override
  set data(List<String> newData) {
    _data = newData;
  }

  @override
  String get selectedData => locator<LocalStorageService>().languageCode;

  @override
  String get dialogTitleText => LocaleKeys.confirmation_languageTitle.tr();

  @override
  String get dialogContentText => LocaleKeys.confirmation_languageContent.tr();

  @override
  Future<List<String>> getSelections() async {
    return Future<List<String>>.value(
      LanguageEnum.values
          .map((LanguageEnum language) => language.languageText)
          .toList(),
    );
  }

  @override
  Future<void> setNewSelection(String languageName) async {
    LanguageEnum lang = LanguageEnum.fromString(languageName);
    if (viewModel?.isUserLoggedIn ?? false) {
      await viewModel?.updateLanguageAndCurrencyCode(languageCode: lang.code);
    } else {
      await syncLanguageAndCurrencyCode(
        languageCode: lang.code,
      );
    }
  }

  @override
  bool isSelected(int index) {
    String value = LanguageEnum.fromString(_data[index]).code;
    return value.toLowerCase() == selectedData.toLowerCase();
  }

  @override
  DynamicSelectionViewModel? viewModel;
}

class DynamicSelectionViewModel extends BaseModel {
  late DynamicSelectionViewDataSource dataSource;

  @override
  Future<void> onViewModelReady() async {
    dataSource.viewModel = this;
    setViewState(ViewState.busy);
    List<String> response = await dataSource.getSelections();
    if (response.isEmpty) {
      navigationService.back();
    }
    dataSource.data = response;
    notifyListeners();
    setViewState(ViewState.idle);
  }

  Future<void> onSelectionTapped(String code) async {
    SheetResponse<EmptyBottomSheetResponse>? confirmationResponse =
        await bottomSheetService.showCustomSheet(
      enableDrag: false,
      isScrollControlled: true,
      data: ConfirmationSheetRequest(
        titleText: dataSource.dialogTitleText,
        contentText: dataSource.dialogContentText,
        selectedText: code,
      ),
      variant: BottomSheetType.confirmationSheet,
    );
    log("Selection changed: ${confirmationResponse?.confirmed}");
    if (confirmationResponse?.confirmed ?? false) {
      await dataSource.setNewSelection(code);
      refreshData();
      locator<HomePagerViewModel>().changeSelectedTabIndex(index: 0);
      navigationService.back();
    }
  }

  Future<void> updateLanguageAndCurrencyCode({
    String? languageCode,
    String? currencyCode,
  }) async {
    bool hasNewLanguageCode = hasLanguageCodeChanged(languageCode);
    bool hasNewCurrencyCode = hasCurrencyCodeChanged(currencyCode);

    if (hasNewLanguageCode || hasNewCurrencyCode) {
      setViewState(ViewState.busy);
      Resource<AuthResponseModel> updateInfoResponse =
          await UpdateUserInfoUseCase(locator<ApiAuthRepository>()).execute(
        UpdateUserInfoParams(
          languageCode: languageCode,
          currencyCode: currencyCode,
        ),
      );

      await handleResponse(
        updateInfoResponse,
        onSuccess: (Resource<AuthResponseModel> response) async {
          String? apiCurrency = response.data?.userInfo?.currencyCode;
          String? apiLanguageCode = response.data?.userInfo?.language;

          await syncLanguageAndCurrencyCode(
            languageCode: apiLanguageCode,
            currencyCode: apiCurrency,
          );
        },
      );
      setViewState(ViewState.idle);
    }
  }
}
