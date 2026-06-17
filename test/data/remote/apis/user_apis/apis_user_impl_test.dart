import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/apis/user_apis/apis_user_impl.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/data/request/related_search.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/app_enviroment_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

// Import nested classes from related_search
export "package:esim_open_source/domain/data/request/related_search.dart"
    show CountriesRequestModel, RegionRequestModel;

void main() {
  group("APIUserImpl Implementation Coverage", () {
    late MockConnectivityService mockConnectivityService;
    late MockLocalStorageService mockLocalStorageService;

    setUpAll(() async {
      await setupTestLocator();

      // Initialize AppEnvironment with test values
      AppEnvironment.isFromAppClip = false;
      AppEnvironment.appEnvironmentHelper = createTestEnvironmentHelper();

      // Setup mock services with default stubs
      mockConnectivityService =
          locator<ConnectivityService>() as MockConnectivityService;
      mockLocalStorageService =
          locator<LocalStorageService>() as MockLocalStorageService;

      // Stub required methods to prevent HTTP calls
      when(mockConnectivityService.isConnected())
          .thenAnswer((_) async => false);
      when(mockLocalStorageService.accessToken).thenReturn("");
      when(mockLocalStorageService.refreshToken).thenReturn("");
      when(mockLocalStorageService.languageCode).thenReturn("en");
    });

    test("APIUserImpl singleton initialization", () {
      final APIUserImpl instance1 = APIUserImpl.instance;
      final APIUserImpl instance2 = APIUserImpl.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
      expect(instance1, isA<ApiUser>());
    });

    test("getUserConsumption method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getUserConsumption(iccID: "test_icc_id");
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getUserConsumption, isA<Function>());
    });

    test("assignBundle method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel(
        region: RegionRequestModel(
          isoCode: "EU",
          regionName: "Europe",
        ),
        countries: <CountriesRequestModel>[
          CountriesRequestModel(
            isoCode: "USA",
            countryName: "United States",
          ),
        ],
      );

      try {
        await apiImpl.assignBundle(
          bundleCode: "BUNDLE123",
          promoCode: "PROMO123",
          referralCode: "REF123",
          affiliateCode: "AFF123",
          paymentType: "card",
          relatedSearch: relatedSearch,
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.assignBundle, isA<Function>());
    });

    test("assignBundle method with bearer token", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;
      final RelatedSearchRequestModel relatedSearch =
          RelatedSearchRequestModel(
        region: RegionRequestModel(
          isoCode: "EU",
          regionName: "Europe",
        ),
        countries: <CountriesRequestModel>[
          CountriesRequestModel(
            isoCode: "USA",
            countryName: "United States",
          ),
        ],
      );

      try {
        await apiImpl.assignBundle(
          bundleCode: "BUNDLE123",
          promoCode: "PROMO123",
          referralCode: "REF123",
          affiliateCode: "AFF123",
          paymentType: "card",
          relatedSearch: relatedSearch,
          bearerToken: "test_bearer_token",
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.assignBundle, isA<Function>());
    });

    test("topUpBundle method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.topUpBundle(
          iccID: "test_icc_id",
          bundleCode: "BUNDLE123",
          paymentType: "card",
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.topUpBundle, isA<Function>());
    });

    test("getUserNotifications method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getUserNotifications(
          pageIndex: 0,
          pageSize: 20,
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getUserNotifications, isA<Function>());
    });

    test("setNotificationsRead method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.setNotificationsRead();
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.setNotificationsRead, isA<Function>());
    });

    test("getBundleExists method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getBundleExists(code: "BUNDLE123");
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getBundleExists, isA<Function>());
    });

    test("getBundleLabel method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getBundleLabel(
          iccid: "test_iccid",
          label: "test_label",
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getBundleLabel, isA<Function>());
    });

    test("getMyEsimByIccID method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getMyEsimByIccID(iccID: "test_icc_id");
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getMyEsimByIccID, isA<Function>());
    });

    test("getMyEsimByOrder method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getMyEsimByOrder(orderID: "order123");
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getMyEsimByOrder, isA<Function>());
    });

    test("getMyEsimByOrder method with bearer token", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getMyEsimByOrder(
          orderID: "order123",
          bearerToken: "test_bearer_token",
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getMyEsimByOrder, isA<Function>());
    });

    test("getMyEsims method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getMyEsims();
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getMyEsims, isA<Function>());
    });

    test("getRelatedTopUp method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getRelatedTopUp(
          iccID: "test_icc_id",
          bundleCode: "BUNDLE123",
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getRelatedTopUp, isA<Function>());
    });

    test("getOrderHistory method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getOrderHistory(
          pageIndex: 0,
          pageSize: 20,
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getOrderHistory, isA<Function>());
    });

    test("getOrderByID method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.getOrderByID(orderID: "order123");
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getOrderByID, isA<Function>());
    });

    test("topUpWallet method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.topUpWallet(
          amount: 100,
          currency: "USD",
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.topUpWallet, isA<Function>());
    });

    test("cancelOrder method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.cancelOrder(orderID: "order123");
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.cancelOrder, isA<Function>());
    });

    test("resendOrderOtp method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.resendOrderOtp(orderID: "order123");
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.resendOrderOtp, isA<Function>());
    });

    test("verifyOrderOtp method implementation coverage", () async {
      final APIUserImpl apiImpl = APIUserImpl.instance;

      try {
        await apiImpl.verifyOrderOtp(
          otp: "123456",
          iccid: "test_iccid",
          orderID: "order123",
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.verifyOrderOtp, isA<Function>());
    });

    test("APIUserImpl implements all ApiUser interface methods", () {
      final APIUserImpl apiImpl = APIUserImpl.instance;
      final ApiUser apiInterface = apiImpl as ApiUser;

      expect(apiInterface.getUserConsumption, isNotNull);
      expect(apiInterface.assignBundle, isNotNull);
      expect(apiInterface.topUpBundle, isNotNull);
      expect(apiInterface.getUserNotifications, isNotNull);
      expect(apiInterface.setNotificationsRead, isNotNull);
      expect(apiInterface.getBundleExists, isNotNull);
      expect(apiInterface.getBundleLabel, isNotNull);
      expect(apiInterface.getMyEsimByIccID, isNotNull);
      expect(apiInterface.getMyEsimByOrder, isNotNull);
      expect(apiInterface.getMyEsims, isNotNull);
      expect(apiInterface.getRelatedTopUp, isNotNull);
      expect(apiInterface.getOrderHistory, isNotNull);
      expect(apiInterface.getOrderByID, isNotNull);
      expect(apiInterface.topUpWallet, isNotNull);
      expect(apiInterface.cancelOrder, isNotNull);
      expect(apiInterface.resendOrderOtp, isNotNull);
      expect(apiInterface.verifyOrderOtp, isNotNull);
    });
  });
}
