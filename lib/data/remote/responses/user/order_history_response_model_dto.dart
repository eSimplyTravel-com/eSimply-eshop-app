import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/user/payment_details_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class OrderHistoryResponseModelDto {
  OrderHistoryResponseModelDto({
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

  factory OrderHistoryResponseModelDto.fromJson({dynamic json}) {
    return OrderHistoryResponseModelDto(
      orderNumber: json["order_number"],
      orderStatus: json["order_status"],
      orderAmount: (json["order_amount"] as num?)?.toDouble(),
      orderCurrency: json["order_currency"],
      orderDate: json["order_date"],
      orderType: json["order_type"],
      quantity: json["quantity"],
      companyName: json["company_name"],
      companyAddress: json["company_address"],
      companyPhone: json["company_phone"],
      companyEmail: json["company_email"],
      companyWebsite: json["company_website"],
      orderDisplayPrice: json["order_display_price"],
      paymentDetails: json["payment_details"] != null
          ? PaymentDetailsResponseModelDto.fromJson(json["payment_details"])
          : null,
      bundleDetails: json["bundle_details"] != null
          ? BundleResponseModelDto.fromJson(json: json["bundle_details"])
          : null,
    );
  }

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
  final PaymentDetailsResponseModelDto? paymentDetails;
  final BundleResponseModelDto? bundleDetails;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "order_number": orderNumber,
      "order_status": orderStatus,
      "order_amount": orderAmount,
      "order_currency": orderCurrency,
      "order_date": orderDate,
      "order_type": orderType,
      "quantity": quantity,
      "company_name": companyName,
      "company_address": companyAddress,
      "company_phone": companyPhone,
      "company_email": companyEmail,
      "company_website": companyWebsite,
      "order_display_price": orderDisplayPrice,
      "payment_details": paymentDetails?.toJson(),
      "bundle_details": bundleDetails?.toJson(),
    };
  }

  static List<OrderHistoryResponseModelDto> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      json: json,
      parser: OrderHistoryResponseModelDto.fromJson,
    );
  }

  OrderHistoryResponseModel toDomain() {
    OrderHistoryResponseModel response = OrderHistoryResponseModel(
      orderNumber: orderNumber,
      orderStatus: orderStatus,
      orderAmount: orderAmount,
      orderCurrency: orderCurrency,
      orderDate: orderDate,
      orderType: orderType,
      quantity: quantity,
      companyName: companyName,
      companyAddress: companyAddress,
      companyPhone: companyPhone,
      companyEmail: companyEmail,
      companyWebsite: companyWebsite,
      orderDisplayPrice: orderDisplayPrice,
      paymentDetails: paymentDetails?.toDomain(),
      bundleDetails: bundleDetails?.toDomain(),
    );

    return response;
  }

  List<OrderHistoryResponseModelDto> mockData() {
    String mockOrderNumber = "ada2964e-81df-4a39-ab34-f1adde6e7b15";
    String mockOrderStatus = "order status";
    String mockOrderType = "order Type";
    String mockCompanyName = "Monty Mobile";
    String mockOrderDisplayPrice = "2.5 USD";
    String mockOrderCurrency = "USD";
    String mockOrderDate = "12344";

    return <OrderHistoryResponseModelDto>[
      OrderHistoryResponseModelDto(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModelDto().mockData(),
        bundleDetails: BundleResponseModelDto.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModelDto(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModelDto().mockData(),
        bundleDetails: BundleResponseModelDto.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModelDto(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModelDto().mockData(),
        bundleDetails: BundleResponseModelDto.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModelDto(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModelDto().mockData(),
        bundleDetails: BundleResponseModelDto.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModelDto(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModelDto().mockData(),
        bundleDetails: BundleResponseModelDto.getMockGlobalBundles().first,
      ),
      OrderHistoryResponseModelDto(
        orderNumber: mockOrderNumber,
        orderStatus: mockOrderStatus,
        orderAmount: 355,
        orderCurrency: mockOrderCurrency,
        orderDate: mockOrderDate,
        orderType: mockOrderType,
        quantity: 2,
        companyName: mockCompanyName,
        orderDisplayPrice: mockOrderDisplayPrice,
        paymentDetails: PaymentDetailsResponseModelDto().mockData(),
        bundleDetails: BundleResponseModelDto.getMockGlobalBundles().first,
      ),
    ];
  }
}
