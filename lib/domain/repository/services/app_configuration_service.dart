import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";

abstract class AppConfigurationService {
  Future<void> getAppConfigurations();

  Future<String> get getSupabaseUrl;
  Future<String> get getSupabaseAnon;
  Future<String> get getWhatsAppNumber;

  /// Whether a WhatsApp number is configured at all, readable synchronously so
  /// the UI can decide not to offer a chat button it cannot honour.
  bool get isWhatsAppAvailable;
  Future<String> get getCatalogVersion;
  String get getDefaultCurrency;
  List<PaymentType>? get getPaymentTypes;
  LoginType?  get getLoginType;
  String get getCashbackDiscount;
}
