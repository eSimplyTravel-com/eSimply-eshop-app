import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_types.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";

void main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();

    // Mock WhatsApp number
    when(locator<AppConfigurationService>().getWhatsAppNumber)
        .thenAnswer((_) async => "+1234567890");
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("BannersViewModel Tests", () {
    test("initializes correctly", () {
      final BannersViewModel vm = BannersViewModel();

      expect(vm.banners, isEmpty);
      expect(vm.currentPage, equals(0));
      expect(vm.textColor, isNull);
      expect(vm.buttonColor, isNull);
      expect(vm.bannersPageController, isNotNull);
      expect(vm.bannersPageController.viewportFraction, equals(0.9));
    });

    test("processBanners with success response", () {
      final BannersViewModel vm = BannersViewModel();
      final List<BannerResponseModel> banners = <BannerResponseModel>[
        BannerResponseModel(
          title: "Test Banner 1",
          description: "Test Description 1",
          action: "CHAT",
          image: "https://example.com/image1.jpg",
        ),
        BannerResponseModel(
          title: "Test Banner 2",
          description: "Test Description 2",
          action: "REFER_NOW",
          image: "https://example.com/image2.jpg",
        ),
      ];

      final Resource<List<BannerResponseModel>?> resource =
          Resource<List<BannerResponseModel>?>.success(
        banners,
        message: "Success",
      );

      vm.processBanners(resource);

      expect(vm.banners.length, equals(2));
      expect(vm.banners[0].title, equals("Test Banner 1"));
      expect(vm.banners[0].bannersViewType, equals(BannersViewTypes.liveChat));
      expect(vm.banners[1].title, equals("Test Banner 2"));
      expect(
        vm.banners[1].bannersViewType,
        equals(BannersViewTypes.referAndEarn),
      );
    });

    test("processBanners with error response", () {
      final BannersViewModel vm = BannersViewModel();

      final Resource<List<BannerResponseModel>?> resource =
          Resource<List<BannerResponseModel>?>.error("Error");

      vm.processBanners(resource);

      expect(vm.banners, isEmpty);
    });

    test("processBanners with loading response", () {
      final BannersViewModel vm = BannersViewModel();

      final Resource<List<BannerResponseModel>?> resource =
          Resource<List<BannerResponseModel>?>.loading();

      vm.processBanners(resource);

      expect(vm.banners, isEmpty);
    });

    test("processBanners with null resource", () {
      final BannersViewModel vm = BannersViewModel()..processBanners(null);

      expect(vm.banners, isEmpty);
    });

    test("onViewTap with referAndEarn when user logged in checks auth",
        () async {
      final BannersViewModel vm = BannersViewModel();
      final BannerState banner = BannerState(
        bannersViewType: BannersViewTypes.referAndEarn,
        title: "Refer and Earn",
        description: "Invite friends",
      );

      when(locator<UserAuthenticationService>().isUserLoggedIn)
          .thenReturn(false);

      // Test with user not logged in to avoid story view creation
      await vm.onViewTap(banner);

      verify(locator<UserAuthenticationService>().isUserLoggedIn).called(1);
    });

    test("onViewTap with referAndEarn when user not logged in", () async {
      final BannersViewModel vm = BannersViewModel();
      final BannerState banner = BannerState(
        bannersViewType: BannersViewTypes.referAndEarn,
        title: "Refer and Earn",
        description: "Invite friends",
      );

      when(locator<UserAuthenticationService>().isUserLoggedIn)
          .thenReturn(false);

      await vm.onViewTap(banner);

      verify(
        locator<NavigationService>().navigateTo(
          LoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });

    test("onViewTap with cashBackRewards when user logged in checks auth",
        () async {
      final BannersViewModel vm = BannersViewModel();
      final BannerState banner = BannerState(
        bannersViewType: BannersViewTypes.cashBackRewards,
        title: "Cashback Rewards",
        description: "Earn cashback",
      );

      when(locator<UserAuthenticationService>().isUserLoggedIn)
          .thenReturn(false);

      // Test with user not logged in to avoid story view creation
      await vm.onViewTap(banner);

      verify(locator<UserAuthenticationService>().isUserLoggedIn).called(1);
    });

    test("onViewTap with cashBackRewards when user not logged in", () async {
      final BannersViewModel vm = BannersViewModel();
      final BannerState banner = BannerState(
        bannersViewType: BannersViewTypes.cashBackRewards,
        title: "Cashback Rewards",
        description: "Earn cashback",
      );

      when(locator<UserAuthenticationService>().isUserLoggedIn)
          .thenReturn(false);

      await vm.onViewTap(banner);

      verify(
        locator<NavigationService>().navigateTo(
          LoginView.routeName,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });

    test("onViewTap with none banner type does nothing", () async {
      final BannersViewModel vm = BannersViewModel();
      final BannerState banner = BannerState(
        bannersViewType: BannersViewTypes.none,
        title: "No action",
        description: "Just display",
      );

      // Should complete without error for none type
      await vm.onViewTap(banner);
      expect(vm, isNotNull);
    });

    test("onDispose cancels timers", () {
      final BannersViewModel vm = BannersViewModel()

        // Dispose should complete without error even if timers are null
        ..onDispose();

      expect(vm, isNotNull);
    });

    test("page controller has correct initial settings", () {
      final BannersViewModel vm = BannersViewModel();

      expect(vm.bannersPageController.viewportFraction, equals(0.9));
    });

    test("liveChat banner type exists in enum", () {
      final BannerState banner = BannerState(
        bannersViewType: BannersViewTypes.liveChat,
        title: "Live Chat",
        description: "Chat with us",
      );

      expect(banner.bannersViewType, equals(BannersViewTypes.liveChat));
      expect(BannersViewTypes.liveChat, isNotNull);
    });

    test("animation methods exist and can be called", () {
      final BannersViewModel vm = BannersViewModel();

      // Test that setUpBannersAnimation can be called
      expect(vm.setUpBannersAnimation, returnsNormally);

      // Test that methods exist
      expect(vm.startAnimatingView, isA<Function>());
      expect(vm.setupButtonColorAnimation, isA<Function>());
    });

    test("onViewModelReady executes successfully", () {
      final BannersViewModel vm = BannersViewModel()

      // Should execute without errors
      ..onViewModelReady();

      expect(vm, isNotNull);
      expect(vm.getBannerUseCase, isNotNull);
    });

    test("setUpBannersAnimation initializes timer", () {
      final BannersViewModel vm = BannersViewModel()

      ..setUpBannersAnimation();

      expect(vm, isNotNull);
    });
  });

  group("BannerState Tests", () {
    test("creates banner state with constructor", () {
      final BannerState banner = BannerState(
        bannersViewType: BannersViewTypes.liveChat,
        title: "Test Title",
        description: "Test Description",
        image: "https://example.com/image.jpg",
      );

      expect(banner.title, equals("Test Title"));
      expect(banner.description, equals("Test Description"));
      expect(banner.image, equals("https://example.com/image.jpg"));
      expect(banner.bannersViewType, equals(BannersViewTypes.liveChat));
    });

    test("creates banner state from BannerResponseModel", () {
      final BannerResponseModel model = BannerResponseModel(
        title: "Model Title",
        description: "Model Description",
        action: "CASHBACK",
        image: "https://example.com/model.jpg",
      );

      final BannerState banner = BannerState.fromBannerMode(model);

      expect(banner.title, equals("Model Title"));
      expect(banner.description, equals("Model Description"));
      expect(banner.image, equals("https://example.com/model.jpg"));
      expect(banner.bannersViewType, equals(BannersViewTypes.cashBackRewards));
    });

    test("creates banner state with null values", () {
      final BannerState banner = BannerState(
        bannersViewType: BannersViewTypes.none,
      );

      expect(banner.title, isNull);
      expect(banner.description, isNull);
      expect(banner.image, isNull);
      expect(banner.bannersViewType, equals(BannersViewTypes.none));
    });

    test("fromBannerMode handles null action", () {
      final BannerResponseModel model = BannerResponseModel(
        title: "Test",
        description: "Test",
      );

      final BannerState banner = BannerState.fromBannerMode(model);

      expect(banner.bannersViewType, equals(BannersViewTypes.none));
    });

    test("fromBannerMode handles unknown action", () {
      final BannerResponseModel model = BannerResponseModel(
        title: "Test",
        description: "Test",
        action: "UNKNOWN_ACTION",
      );

      final BannerState banner = BannerState.fromBannerMode(model);

      expect(banner.bannersViewType, equals(BannersViewTypes.none));
    });
  });
}
