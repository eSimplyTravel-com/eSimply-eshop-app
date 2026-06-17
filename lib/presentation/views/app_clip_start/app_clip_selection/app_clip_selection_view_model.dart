import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_currencies_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/language_enum.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

enum AppClipSelectionTypes {
  language,
  currency;

  String get title {
    switch (this) {
      case AppClipSelectionTypes.language:
        return LocaleKeys.appClip_languageTitle.tr();
      case AppClipSelectionTypes.currency:
        return LocaleKeys.appClip_currencyTitle.tr();
    }
  }
}

class AppClipSelectionViewModel extends BaseModel {
  String selectedLanguage = "";
  String selectedCurrency = "";
  AppClipSelectionTypes selectionType = AppClipSelectionTypes.language;
  List<String> currencies = <String>[];

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();
    await getCurrencies();
  }

  Future<void> getCurrencies() async {
    setViewState(ViewState.busy);
    GetCurrenciesUseCase getCurrenciesUseCase =
        GetCurrenciesUseCase(locator<ApiAppRepository>());

    Resource<List<CurrenciesResponseModel>?> response =
        await getCurrenciesUseCase.execute(NoParams());

    await handleResponse(
      response,
      onSuccess: (Resource<List<CurrenciesResponseModel>?> response) async {
        currencies = response.data
                ?.map((CurrenciesResponseModel e) => e.currency ?? "")
                .where((String item) => item.trim().isNotEmpty)
                .toList() ??
            <String>[];
      },
      onFailure: (Resource<List<CurrenciesResponseModel>?> response) async {
        currencies = <String>[];
      },
    );

    setViewState(ViewState.idle);
  }

  bool isSelected(int index) {
    if (selectionType == AppClipSelectionTypes.language) {
      return selectedLanguage == LanguageEnum.values[index].languageText;
    }
    return selectedCurrency == currencies[index];
  }

  bool get isButtonEnabled {
    if (selectionType == AppClipSelectionTypes.language) {
      return selectedLanguage.isNotEmpty;
    }
    return selectedCurrency.isNotEmpty;
  }

  int itemCount() {
    if (selectionType == AppClipSelectionTypes.language) {
      return LanguageEnum.values.length;
    }
    return currencies.length;
  }

  String itemValue(int index) {
    if (selectionType == AppClipSelectionTypes.language) {
      return LanguageEnum.values[index].languageText;
    }
    return currencies[index];
  }

  Future<void> onSelection(BuildContext context, int index) async {
    if (selectionType == AppClipSelectionTypes.language) {
      selectedLanguage = LanguageEnum.values[index].languageText;
      String selectedLanguageCode =
          LanguageEnum.fromString(selectedLanguage).code;
      await context.setLocale(Locale(selectedLanguageCode.toLowerCase()));
      await localStorageService.setString(
        LocalStorageKeys.appLanguage,
        selectedLanguageCode.toLowerCase(),
      );
    } else {
      selectedCurrency = currencies[index];
      await localStorageService.setString(
        LocalStorageKeys.appCurrency,
        selectedCurrency,
      );
      refreshData();
    }
    notifyListeners();
  }

  Future<void> onButtonTapped() async {
    if (selectionType == AppClipSelectionTypes.language &&
        currencies.isNotEmpty) {
      selectionType = AppClipSelectionTypes.currency;
      notifyListeners();
      return;
    }
    await navigateToHomePager();
    notifyListeners();
  }
}
