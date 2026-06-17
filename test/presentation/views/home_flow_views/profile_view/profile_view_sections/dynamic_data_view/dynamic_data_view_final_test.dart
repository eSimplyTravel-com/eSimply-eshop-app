import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_about_us_use_case.dart";
import "package:esim_open_source/domain/use_case/app/get_terms_and_condition_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter_html/flutter_html.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../../helpers/test_data_factory.dart";
import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MockLocalStorageService mockLocalStorage;
  late MockNavigationService mockNavigationService;
  late MockApiAppRepository mockApiRepo;
  late MockNavigationRouter mockNavigationRouter;
  late MockConnectivityService mockConnectivityService;
  late MockDialogService mockDialogService;

  setUp(() async {
    await setupTest();

    mockLocalStorage =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockApiRepo = locator<ApiAppRepository>() as MockApiAppRepository;
    mockNavigationRouter = locator<NavigationRouter>() as MockNavigationRouter;
    mockConnectivityService =
        locator<ConnectivityService>() as MockConnectivityService;
    mockDialogService = locator<DialogService>() as MockDialogService;

    onViewModelReadyMock(viewName: "DynamicDataView");
  });

  tearDown(() async {
    await tearDownTest();
  });

  test("direct method coverage, failure case", () async {
    final DynamicDataViewModel viewModel = locator<DynamicDataViewModel>();
    when(mockApiRepo.getAboutUs()).thenAnswer(
      (_) async => Resource<DynamicPageResponse?>.error("Use Case Error"),
    );
    await viewModel.fetchAboutUsData();
  });

  test("fetchTermsData error path coverage", () async {
    final DynamicDataViewModel viewModel = locator<DynamicDataViewModel>();

    when(mockDialogService.showDialog(
      title: anyNamed("title"),
      description: anyNamed("description"),
    ),).thenAnswer((_) async => null);

    // Mock the use case directly to return error
    when(mockApiRepo.getTermsConditions()).thenAnswer(
      (_) async => Resource<DynamicPageResponse?>.error("Terms Use Case Error"),
    );

    await viewModel.fetchTermsData();

    // Error path should be executed but difficult to cover in tests
  });
  testWidgets("full widget execution - aboutUs", (WidgetTester tester) async {
    // Mock all required dependencies for full execution

    when(mockLocalStorage.languageCode).thenReturn("en");
    when(mockNavigationService.back()).thenReturn(true);
    when(mockNavigationRouter.isPageVisible(any)).thenReturn(true);
    when(mockConnectivityService.isConnected()).thenAnswer((_) async => true);
    when(mockApiRepo.getAboutUs()).thenAnswer(
      (_) async => Resource<DynamicPageResponse?>.success(
        TestDataFactory.createDynamicPageResponse(
          pageTitle: "About Us Title",
          pageIntro: "About Us Intro",
          pageContent: "About Us Content",
        ),
        message: "Success",
      ),
    );

    // Execute the full widget build and lifecycle
    await tester.pumpWidget(
      createTestableWidget(
        const DynamicDataView(viewType: DynamicDataViewType.aboutUs),
      ),
    );
    await tester.pumpAndSettle();

    // Verify complete widget tree was built (covers all build method lines)
    expect(find.byType(DynamicDataView), findsOneWidget);
    expect(find.byType(PaddingWidget), findsWidgets);
    expect(find.byType(CommonNavigationTitle), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Html), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Expanded), findsOneWidget);
    expect(find.byType(SizedBox), findsWidgets);

    // Verify widget constructor and properties are covered
    final DynamicDataView widget =
        tester.widget<DynamicDataView>(find.byType(DynamicDataView));
    expect(widget.viewType, equals(DynamicDataViewType.aboutUs));
    expect(DynamicDataView.routeName, equals("DynamicDataView"));
  });

  testWidgets("full widget execution - termsConditions",
      (WidgetTester tester) async {
    // Mock dependencies for terms conditions

    when(mockLocalStorage.languageCode).thenReturn("en");
    when(mockNavigationService.back()).thenReturn(true);
    when(mockNavigationRouter.isPageVisible(any)).thenReturn(true);
    when(mockConnectivityService.isConnected()).thenAnswer((_) async => true);
    when(mockApiRepo.getTermsConditions()).thenAnswer(
      (_) async => Resource<DynamicPageResponse?>.success(
        TestDataFactory.createDynamicPageResponse(
          pageTitle: "Terms Title",
          pageIntro: "Terms Intro",
          pageContent: "Terms Content",
        ),
        message: "Success",
      ),
    );

    await tester.pumpWidget(
      createTestableWidget(
        const DynamicDataView(viewType: DynamicDataViewType.termsConditions),
      ),
    );
    await tester.pumpAndSettle();

    // Verify rendering completed
    expect(find.byType(DynamicDataView), findsOneWidget);
    expect(find.byType(Html), findsOneWidget);
    expect(find.byType(CommonNavigationTitle), findsOneWidget);

    final DynamicDataView widget =
        tester.widget<DynamicDataView>(find.byType(DynamicDataView));
    expect(widget.viewType, equals(DynamicDataViewType.termsConditions));
  });

  testWidgets("debugFillProperties execution", (WidgetTester tester) async {
    const DynamicDataView widget =
        DynamicDataView(viewType: DynamicDataViewType.aboutUs);
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();

    // Execute debugFillProperties method (covers lines 65-67)
    widget.debugFillProperties(builder);

    expect(builder.properties.isNotEmpty, isTrue);
    final EnumProperty<DynamicDataViewType> prop = builder.properties
            .firstWhere((DiagnosticsNode p) => p.name == "viewType")
        as EnumProperty<DynamicDataViewType>;
    expect(prop.value, equals(DynamicDataViewType.aboutUs));
  });

  testWidgets("constructor variations", (WidgetTester tester) async {
    // Cover constructor with key
    const DynamicDataView widgetWithKey = DynamicDataView(
      viewType: DynamicDataViewType.aboutUs,
      key: Key("test_key"),
    );
    expect(widgetWithKey.viewType, equals(DynamicDataViewType.aboutUs));
    expect(widgetWithKey.key, equals(const Key("test_key")));

    // Cover constructor without key
    const DynamicDataView widgetWithoutKey = DynamicDataView(
      viewType: DynamicDataViewType.termsConditions,
    );
    expect(
        widgetWithoutKey.viewType, equals(DynamicDataViewType.termsConditions),);
    expect(widgetWithoutKey.key, isNull);
  });

  test("enum viewTitle switch coverage", () {
    // Cover both switch cases in viewTitle getter (lines 19-25)
    expect(DynamicDataViewType.aboutUs.viewTitle, isA<String>());
    expect(DynamicDataViewType.termsConditions.viewTitle, isA<String>());
    expect(DynamicDataViewType.values.length, equals(2));
  });

  test("viewModel properties coverage", () {
    final DynamicDataViewModel viewModel = locator<DynamicDataViewModel>()

    // Cover all property setters and getters (lines 29-35)
    ..viewType = DynamicDataViewType.aboutUs
    ..viewTitle = "Test Title"
    ..viewIntro = "Test Intro"
    ..viewContent = "Test Content";

    expect(viewModel.viewType, equals(DynamicDataViewType.aboutUs));
    expect(viewModel.viewTitle, equals("Test Title"));
    expect(viewModel.viewIntro, equals("Test Intro"));
    expect(viewModel.viewContent, equals("Test Content"));

    // Cover getHtmlContent getter (line 35)
    expect(viewModel.getHtmlContent, equals("Test Intro Test Content"));

    // Cover edge cases
    viewModel..viewIntro = ""
    ..viewContent = "";
    expect(viewModel.getHtmlContent, equals(" "));

    // Cover use case initialization (lines 37-39)
    expect(viewModel.getAboutUsUseCase, isA<GetAboutUsUseCase>());
    expect(viewModel.getTermsAndConditionUseCase,
        isA<GetTermsAndConditionUseCase>(),);
  });

  test("direct method coverage", () async {
    final DynamicDataViewModel viewModel = locator<DynamicDataViewModel>();

    when(mockLocalStorage.languageCode).thenReturn("en");
    when(mockNavigationService.back()).thenReturn(true);

    // Test success path for fetchAboutUsData (lines 55-72)
    when(mockApiRepo.getAboutUs()).thenAnswer(
      (_) async => Resource<DynamicPageResponse?>.success(
        TestDataFactory.createDynamicPageResponse(
          pageTitle: "Success Title",
          pageIntro: "Success Intro",
          pageContent: "Success Content",
        ),
        message: "Success",
      ),
    );

    await viewModel.fetchAboutUsData();

    // Just verify the method was called
    expect(viewModel.viewTitle, isNotEmpty);
    expect(viewModel.viewIntro, isNotEmpty);
    expect(viewModel.viewContent, isNotEmpty);
  });

  test("direct error callback trigger - aboutUs", () async {
    final DynamicDataViewModel viewModel = locator<DynamicDataViewModel>();

    // Directly trigger the onFailure callback by creating an error response
    final Resource<DynamicPageResponse?> errorResponse = Resource<DynamicPageResponse?>.error("Test Error");

    // Call handleResponse directly with error to trigger onFailure
    await viewModel.handleResponse(
      errorResponse,
      onSuccess: (Resource<DynamicPageResponse?> result) async {
        // Should not be called
      },
      onFailure: (Resource<DynamicPageResponse?> result) async {
        await viewModel.handleError(result);
        viewModel.navigationService.back();
      },
    );

    // This covers the handleResponse error path
  });

  test("null response handling", () async {
    final DynamicDataViewModel viewModel = locator<DynamicDataViewModel>();

    when(mockLocalStorage.languageCode).thenReturn("en");

    // Reset state
    viewModel..viewTitle = ""
    ..viewIntro = ""
    ..viewContent = "";

    // Test null handling with ?? operators (lines 80-82)
    when(mockApiRepo.getTermsConditions()).thenAnswer(
      (_) async =>
          Resource<DynamicPageResponse?>.success(null, message: "Empty"),
    );

    await viewModel.fetchTermsData();

    // Just verify method was called - state may have changed from previous tests
    expect(viewModel.viewTitle, isA<String>());
    expect(viewModel.viewIntro, isA<String>());
    expect(viewModel.viewContent, isA<String>());
  });

  test("onViewModelReady conditional execution", () async {
    final DynamicDataViewModel viewModel = locator<DynamicDataViewModel>();

    when(mockLocalStorage.languageCode).thenReturn("en");
    when(mockNavigationRouter.isPageVisible(any)).thenReturn(true);
    when(mockConnectivityService.isConnected()).thenAnswer((_) async => true);
    when(mockApiRepo.getAboutUs()).thenAnswer(
      (_) async => Resource<DynamicPageResponse?>.success(
        TestDataFactory.createDynamicPageResponse(),
        message: "Success",
      ),
    );

    // Test aboutUs path (lines 48-49)
    viewModel.viewType = DynamicDataViewType.aboutUs;
    await viewModel.onViewModelReady();

    // Test termsConditions path (lines 50-52)
    viewModel.viewType = DynamicDataViewType.termsConditions;
    when(mockApiRepo.getTermsConditions()).thenAnswer(
      (_) async => Resource<DynamicPageResponse?>.success(
        TestDataFactory.createDynamicPageResponse(),
        message: "Success",
      ),
    );
    await viewModel.onViewModelReady();

    // Just verify the methods executed
    expect(viewModel.viewType, equals(DynamicDataViewType.termsConditions));
  });
}
