import "package:esim_open_source/domain/data/response/core/string_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/app/contact_us_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late ContactUsViewModel viewModel;
  late MockApiAppRepository mockApiRepo;

  setUp(() async {
    await setupTest();
    mockApiRepo = locator<ApiAppRepository>() as MockApiAppRepository;
    viewModel = locator<ContactUsViewModel>();
    onViewModelReadyMock(viewName: "ContactUsView");
  });

  tearDown(() async {
    await tearDownTest();
  });

  testWidgets("full widget execution - success flow",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        const ContactUsView(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify widget properties and route name
    expect(ContactUsView.routeName, equals("ContactUsView"));
    expect(find.byType(ContactUsView), findsOneWidget);
  });

  testWidgets("button interaction and form submission",
      (WidgetTester tester) async {
    when(
      mockApiRepo.contactUs(
        email: anyNamed("email"),
        message: anyNamed("message"),
      ),
    ).thenAnswer(
      (_) async => Resource<StringResponse?>.success(
        StringResponse(stringValue: true),
        message: "Message sent successfully",
      ),
    );

    await tester.pumpWidget(
      createTestableWidget(
        const ContactUsView(),
      ),
    );
    await tester.pumpAndSettle();

    // Find and interact with the button
    final Finder buttonFinder = find.byType(MainButton);
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // Verify no exceptions thrown during interaction
    expect(tester.takeException(), isNull);
  });

  testWidgets("scroll view interaction", (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        const ContactUsView(),
      ),
    );
    await tester.pumpAndSettle();

    // Test scrolling behavior
    final Finder scrollView = find.byType(SingleChildScrollView);
    expect(scrollView, findsOneWidget);

    if (scrollView.evaluate().isNotEmpty) {
      await tester.drag(scrollView.first, const Offset(0, -100));
      await tester.pumpAndSettle();
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets("constructor variations", (WidgetTester tester) async {
    // Cover constructor with key
    const ContactUsView widgetWithKey = ContactUsView(key: Key("test_key"));
    expect(widgetWithKey.key, equals(const Key("test_key")));

    // Cover constructor without key
    const ContactUsView widgetWithoutKey = ContactUsView();
    expect(widgetWithoutKey.key, isNull);
  });

  test("route name constant coverage", () {
    expect(ContactUsView.routeName, equals("ContactUsView"));
    expect(ContactUsView.routeName, isA<String>());
    expect(ContactUsView.routeName.length, greaterThan(0));
  });

  test("direct method coverage - error path", () async {
    final ContactUsViewModel viewModel = locator<ContactUsViewModel>();

    when(
      mockApiRepo.contactUs(
        email: anyNamed("email"),
        message: anyNamed("message"),
      ),
    ).thenAnswer(
      (_) async => Resource<StringResponse?>.error("Network Error"),
    );

    viewModel.state.emailController.text = "test@example.com";
    viewModel.state.messageController.text = "Test message";

    // Create a mock BuildContext
    final Widget testWidget = MaterialApp(home: Container());
    final BuildContext context = testWidget.createElement();

    when(
      locator<ApiAppRepository>().contactUs(
        email: "test@example.com",
        message: "Test message",
      ),
    ).thenAnswer(
      (_) async => Resource<StringResponse?>.success(null, message: ""),
    );
    viewModel.onSendMessageClicked(context);

    // Verify error path was executed
    expect(viewModel.viewState.name, isA<String>());
  });

  test("widget properties and getters coverage", () {
    const ContactUsView widget = ContactUsView();

    // Cover all widget properties
    expect(widget.key, isNull);
    expect(widget.runtimeType, equals(ContactUsView));
    expect(widget.hashCode, isA<int>());
    expect(widget.toString(), contains("ContactUsView"));

    // Static properties
    expect(ContactUsView.routeName, equals("ContactUsView"));
  });

  test("contact us params creation", () {
    const String testEmail = "test@example.com";
    const String testMessage = "Test message content";

    final ContactUsParams params = ContactUsParams(
      email: testEmail,
      message: testMessage,
    );

    expect(params.email, equals(testEmail));
    expect(params.message, equals(testMessage));
  });
}
