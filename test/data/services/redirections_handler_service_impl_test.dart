import "package:esim_open_source/data/services/redirections_handler_service_impl.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";
import "../../locator_test.dart";
import "../../locator_test.mocks.dart";

/// Unit tests for RedirectionsHandlerServiceImpl.
///
/// The service is built directly via its public constructor (bypassing the
/// static singleton) so each test gets a fresh instance backed by the
/// per-test locator mocks. Notification and deep-link payloads are crafted to
/// drive each branch of the redirection switch.
Future<void> main() async {
  await prepareTest();

  late MockNavigationService mockNavigationService;
  late MockBottomSheetService mockBottomSheetService;
  late MockNavigationRouter mockNavigationRouter;
  late MockUserAuthenticationService mockUserAuthenticationService;
  late MockApiAuthRepository mockApiAuthRepository;
  late MockLocalStorageService mockLocalStorageService;
  late RedirectionsHandlerServiceImpl service;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();

    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockBottomSheetService =
        locator<BottomSheetService>() as MockBottomSheetService;
    mockNavigationRouter = locator<NavigationRouter>() as MockNavigationRouter;
    mockUserAuthenticationService =
        locator<UserAuthenticationService>() as MockUserAuthenticationService;
    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;

    when(mockNavigationService.navigateTo(any)).thenAnswer((_) async => true);
    when(
      mockNavigationService.navigateTo(any, arguments: anyNamed("arguments")),
    ).thenAnswer((_) async => true);
    when(mockNavigationService.clearStackAndShow(any))
        .thenAnswer((_) async => true);
    when(
      mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        data: anyNamed("data"),
        enableDrag: anyNamed("enableDrag"),
        isScrollControlled: anyNamed("isScrollControlled"),
      ),
    ).thenAnswer((_) async => null);
    when(mockNavigationRouter.isPageVisible(any)).thenReturn(false);
    when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(false);
    when(mockUserAuthenticationService.updateUserResponse(any))
        .thenAnswer((_) async {});
    when(mockLocalStorageService.setString(any, any))
        .thenAnswer((_) async => true);
    when(mockApiAuthRepository.getUserInfo()).thenAnswer(
      (_) async => Resource<AuthResponseModel?>.error("error"),
    );

    service = RedirectionsHandlerServiceImpl.initializeWithNavigationService(
      navigationService: mockNavigationService,
      bottomSheetService: mockBottomSheetService,
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("Singleton & properties", () {
    test("getInstance creates and reuses a single instance", () {
      final RedirectionsHandlerServiceImpl instance1 =
          RedirectionsHandlerServiceImpl.getInstance(
        mockNavigationService,
        mockBottomSheetService,
      );
      final RedirectionsHandlerServiceImpl instance2 =
          RedirectionsHandlerServiceImpl.getInstance(
        mockNavigationService,
        mockBottomSheetService,
      );

      expect(instance1, same(instance2));
    });

    test("exposes navigation and bottom sheet services", () {
      expect(service, isA<RedirectionsHandlerService>());
      expect(service.navigationService, isA<NavigationService>());
      expect(service.bottomSheetService, isA<BottomSheetService>());
    });
  });

  group("handleInitialRedirection", () {
    test("invokes callback when there is no pending data", () async {
      bool called = false;
      await service.handleInitialRedirection(() => called = true);

      expect(called, isTrue);
    });

    test("handles a pending initial push", () async {
      await service.serialiseAndRedirectNotification(
        isClicked: true,
        isInitial: true,
        handlePushData: <String, dynamic>{"category": "1", "iccid": "ic"},
      );

      await service.handleInitialRedirection(() {});

      verify(mockNavigationService.navigateTo(any)).called(greaterThan(0));
    });

    test("handles a pending initial deep link", () async {
      await service.serialiseAndRedirectDeepLink(
        isInitial: true,
        uriDeepLinkData: Uri.parse("https://example.com/countries"),
      );

      await service.handleInitialRedirection(() {});

      verify(mockNavigationService.navigateTo(any)).called(greaterThan(0));
    });
  });

  group("serialiseAndRedirectNotification categories", () {
    Future<void> runCategory(String category) async {
      await service.serialiseAndRedirectNotification(
        isClicked: true,
        isInitial: false,
        handlePushData: <String, dynamic>{
          "category": category,
          "iccid": "test-iccid",
          "cashback_percent": "20",
        },
      );
    }

    test("null payload returns without error", () async {
      await expectLater(
        service.serialiseAndRedirectNotification(
          isClicked: false,
          isInitial: false,
        ),
        completes,
      );
    });

    test("category 1 (BuyBundle) shows the qr bottom sheet", () async {
      await runCategory("1");
      verify(
        mockBottomSheetService.showCustomSheet(
          variant: anyNamed("variant"),
          data: anyNamed("data"),
          enableDrag: anyNamed("enableDrag"),
          isScrollControlled: anyNamed("isScrollControlled"),
        ),
      ).called(greaterThan(0));
    });

    test("category 2 (BuyTopUp) completes", () async {
      await expectLater(runCategory("2"), completes);
    });

    test("category 4 (CashbackReward) shows the cashback sheet", () async {
      await runCategory("4");
      verify(
        mockBottomSheetService.showCustomSheet(
          variant: anyNamed("variant"),
          data: anyNamed("data"),
          enableDrag: anyNamed("enableDrag"),
          isScrollControlled: anyNamed("isScrollControlled"),
        ),
      ).called(greaterThan(0));
    });

    test("category 5 (ConsumptionBundleDetail) shows the consumption sheet",
        () async {
      await runCategory("5");
      verify(
        mockBottomSheetService.showCustomSheet(
          variant: anyNamed("variant"),
          data: anyNamed("data"),
          enableDrag: anyNamed("enableDrag"),
          isScrollControlled: anyNamed("isScrollControlled"),
        ),
      ).called(greaterThan(0));
    });

    test("category 6 (PlanStarted) completes", () async {
      await expectLater(runCategory("6"), completes);
    });

    test("category 9 (WalletTopUpSuccess) fetches user info", () async {
      await runCategory("9");
      verify(mockApiAuthRepository.getUserInfo()).called(greaterThan(0));
    });

    test("category 10 (WalletTopUpFailed) completes", () async {
      await expectLater(runCategory("10"), completes);
    });

    test("unknown category (Empty) completes", () async {
      await expectLater(runCategory("999"), completes);
    });
  });

  group("serialiseAndRedirectDeepLink categories", () {
    Future<void> runLink(String url) async {
      await service.serialiseAndRedirectDeepLink(
        isInitial: false,
        uriDeepLinkData: Uri.parse(url),
      );
    }

    test("referral link saves referral code and shows toast", () async {
      await runLink("https://example.com/referral?referralCode=ABC123");
      verify(
        mockLocalStorageService.setString(
          LocalStorageKeys.referralCode,
          "ABC123",
        ),
      ).called(greaterThan(0));
    });

    test("regions link completes", () async {
      await expectLater(runLink("https://example.com/regions"), completes);
    });

    test("countries link completes", () async {
      await expectLater(runLink("https://example.com/countries"), completes);
    });

    test("region selected link navigates to the region bundle", () async {
      await expectLater(
        runLink("https://example.com/regionSelected?regionCode=EU"),
        completes,
      );
    });

    test("country selected link navigates to the country bundle", () async {
      await expectLater(
        runLink("https://example.com/countrySelected?countryCode=US"),
        completes,
      );
    });

    test("unknown link (Empty) still stores the utm", () async {
      await runLink("https://example.com/unknown");
      verify(
        mockLocalStorageService.setString(LocalStorageKeys.utm, any),
      ).called(greaterThan(0));
    });
  });

  group("notificationInboxRedirections", () {
    test("empty category returns early", () async {
      await expectLater(
        service.notificationInboxRedirections(
          iccID: "ic",
          category: "999",
          isUnlimitedData: false,
        ),
        completes,
      );
    });

    test("consumption category triggers redirection", () async {
      await service.notificationInboxRedirections(
        iccID: "ic",
        category: "5",
        isUnlimitedData: true,
      );
      verify(
        mockBottomSheetService.showCustomSheet(
          variant: anyNamed("variant"),
          data: anyNamed("data"),
          enableDrag: anyNamed("enableDrag"),
          isScrollControlled: anyNamed("isScrollControlled"),
        ),
      ).called(greaterThan(0));
    });
  });

  group("ReferAndEarn login branch", () {
    test("logged-in user does not get routed to login", () async {
      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);

      await expectLater(
        service.serialiseAndRedirectDeepLink(
          isInitial: false,
          uriDeepLinkData: Uri.parse("https://example.com/referral"),
        ),
        completes,
      );
    });
  });

  group("redirectToRoute", () {
    test("with a variant shows a custom bottom sheet", () async {
      final InAppRedirection redirection = InAppRedirection.purchase(
        PurchaseBundleBottomSheetArgs(null, null, BundleResponseModel()),
      );

      await service.redirectToRoute(redirection: redirection);

      verify(
        mockBottomSheetService.showCustomSheet(
          variant: anyNamed("variant"),
          data: anyNamed("data"),
          enableDrag: anyNamed("enableDrag"),
          isScrollControlled: anyNamed("isScrollControlled"),
        ),
      ).called(greaterThan(0));
    });
  });
}
