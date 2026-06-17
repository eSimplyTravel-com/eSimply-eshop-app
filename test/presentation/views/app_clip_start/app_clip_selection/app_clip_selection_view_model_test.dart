import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_currencies_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/language_enum.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/views/app_clip_start/app_clip_selection/app_clip_selection_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late AppClipSelectionViewModel viewModel;
  late MockApiAppRepository mockApiAppRepository;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "AppClipSelectionView");
    GetCurrenciesUseCase.previousResponse = null;
    mockApiAppRepository =
        locator<ApiAppRepository>() as MockApiAppRepository;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    viewModel = AppClipSelectionViewModel();
  });

  tearDown(() async {
    GetCurrenciesUseCase.previousResponse = null;
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("AppClipSelectionViewModel Tests", () {
    test("getCurrencies populates currencies list on success", () async {
      final List<CurrenciesResponseModel> currencies =
          <CurrenciesResponseModel>[
        CurrenciesResponseModel(currency: "USD"),
        CurrenciesResponseModel(currency: "EUR"),
        CurrenciesResponseModel(currency: ""),
      ];
      when(mockApiAppRepository.getCurrencies()).thenAnswer(
        (_) async => Resource<List<CurrenciesResponseModel>?>.success(
          currencies,
          message: "Success",
        ),
      );

      await viewModel.getCurrencies();

      expect(viewModel.currencies, equals(<String>["USD", "EUR"]));
    });

    test("getCurrencies sets empty currencies on failure", () async {
      when(mockApiAppRepository.getCurrencies()).thenAnswer(
        (_) async => Resource<List<CurrenciesResponseModel>?>.error("Error"),
      );

      await viewModel.getCurrencies();

      expect(viewModel.currencies, isEmpty);
    });

    test("isSelected and isButtonEnabled for language type", () {
      expect(viewModel.isSelected(0), isFalse);
      expect(viewModel.isButtonEnabled, isFalse);

      viewModel.selectedLanguage = LanguageEnum.english.languageText;

      expect(viewModel.isSelected(0), isTrue);
      expect(viewModel.isSelected(1), isFalse);
      expect(viewModel.isButtonEnabled, isTrue);
    });

    test("isSelected and isButtonEnabled for currency type", () {
      viewModel.selectionType = AppClipSelectionTypes.currency;
      viewModel.currencies = <String>["USD", "EUR"];

      expect(viewModel.isSelected(0), isFalse);
      expect(viewModel.isButtonEnabled, isFalse);

      viewModel.selectedCurrency = "USD";

      expect(viewModel.isSelected(0), isTrue);
      expect(viewModel.isSelected(1), isFalse);
      expect(viewModel.isButtonEnabled, isTrue);
    });

    test("itemCount and itemValue for language type", () {
      expect(viewModel.itemCount(), equals(LanguageEnum.values.length));
      expect(
        viewModel.itemValue(0),
        equals(LanguageEnum.values[0].languageText),
      );
      expect(
        viewModel.itemValue(1),
        equals(LanguageEnum.values[1].languageText),
      );
    });

    test("itemCount and itemValue for currency type", () {
      viewModel.selectionType = AppClipSelectionTypes.currency;
      viewModel.currencies = <String>["USD", "EUR"];

      expect(viewModel.itemCount(), equals(2));
      expect(viewModel.itemValue(0), equals("USD"));
      expect(viewModel.itemValue(1), equals("EUR"));
    });

    test("onButtonTapped switches to currency type when currencies available",
        () async {
      viewModel.currencies = <String>["USD"];

      await viewModel.onButtonTapped();

      expect(viewModel.selectionType, equals(AppClipSelectionTypes.currency));
    });

    test("onButtonTapped navigates home when on currency type", () async {
      viewModel.selectionType = AppClipSelectionTypes.currency;

      await viewModel.onButtonTapped();

      verify(
        locator<NavigationService>().pushNamedAndRemoveUntil(
          HomePager.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });

    test("onButtonTapped navigates home when no currencies", () async {
      expect(viewModel.currencies, isEmpty);

      await viewModel.onButtonTapped();

      verify(
        locator<NavigationService>().pushNamedAndRemoveUntil(
          HomePager.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });

    test("onSelection for currency type updates selectedCurrency", () async {
      viewModel.selectionType = AppClipSelectionTypes.currency;
      viewModel.currencies = <String>["USD", "EUR"];
      when(
        mockLocalStorageService.setString(any, any),
      ).thenAnswer((_) async => true);
      when(
        locator<BundlesDataService>().refreshData(),
      ).thenAnswer((_) async {});

      await viewModel.onSelection(
        MaterialApp(home: Container()).createElement(),
        0,
      );

      expect(viewModel.selectedCurrency, equals("USD"));
    });

    test("getCurrencies handles null response data with empty fallback",
        () async {
      when(mockApiAppRepository.getCurrencies()).thenAnswer(
        (_) async => Resource<List<CurrenciesResponseModel>?>.success(
          null,
          message: "Success",
        ),
      );

      await viewModel.getCurrencies();

      expect(viewModel.currencies, isEmpty);
    });

    testWidgets("onSelection for language type updates selectedLanguage",
        (WidgetTester tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );
      await tester.pump();

      when(
        mockLocalStorageService.setString(any, any),
      ).thenAnswer((_) async => true);

      await viewModel.onSelection(capturedContext, 0);

      expect(
        viewModel.selectedLanguage,
        equals(LanguageEnum.values[0].languageText),
      );
    });

    test("AppClipSelectionTypes titles are non-empty strings", () {
      expect(AppClipSelectionTypes.language.title, isNotEmpty);
      expect(AppClipSelectionTypes.currency.title, isNotEmpty);
    });
  });
}
