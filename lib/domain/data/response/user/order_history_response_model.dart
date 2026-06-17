import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/user/payment_details_response_model.dart";

class OrderHistoryResponseModel {
  OrderHistoryResponseModel({
    this.orderNumber,
    this.orderStatus,
    this.orderAmount,
    this.orderCurrency,
    this.orderDate,
    this.orderType,
    this.quantity,
    this.companyName,
    this.companyAddress,
    this.companyPhone,
    this.companyEmail,
    this.companyWebsite,
    this.orderDisplayPrice,
    this.paymentDetails,
    this.bundleDetails,
  });

  final String? orderNumber;
  final String? orderStatus;
  final double? orderAmount;
  final String? orderCurrency;
  final String? orderDate;
  final String? orderType;
  final int? quantity;
  final String? companyName;
  final String? companyAddress;
  final String? companyPhone;
  final String? companyEmail;
  final String? companyWebsite;
  final String? orderDisplayPrice;
  final PaymentDetailsResponseModel? paymentDetails;
  final BundleResponseModel? bundleDetails;

  List<OrderHistoryResponseModel> mockData() {
    String mockOrderNumber = "ada2964e-81df-4a39-ab34-f1adde6e7b15";
    String mockOrderStatus = "order status";
    String mockOrderType = "order Type";
    String mockCompanyName = "Monty Mobile";
    String mockOrderDisplayPrice = "2.5 USD";
    String mockOrderCurrency = "USD";
    String mockOrderDate = "12344";

    return <OrderHistoryResponseModel>[
      OrderHistoryResponseModel(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModel().mockData(),
        bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModel(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModel().mockData(),
        bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModel(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModel().mockData(),
        bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModel(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModel().mockData(),
        bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModel(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModel().mockData(),
        bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModel(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModel().mockData(),
        bundleDetails: BundleResponseModel.getMockGlobalBundles().first,
      ),
    ];
  }
}
