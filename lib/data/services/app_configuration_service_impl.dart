import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/app/configuration_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/get_configurations_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";

class AppConfigurationServiceImpl extends AppConfigurationService {
  AppConfigurationServiceImpl._privateConstructor();

  static AppConfigurationServiceImpl? _instance;

  static AppConfigurationServiceImpl get instance {
    if (_instance == null) {
      _instance = AppConfigurationServiceImpl._privateConstructor();
      log("Initialize App Configuration Service");
      unawaited(_instance?.getAppConfigurations());
    }
    return _instance!;
  }

  Completer<void>? _appConfigCompleter;
  List<ConfigurationResponseModel>? _configData;

  @override
  Future<void> getAppConfigurations() async {
    _appConfigCompleter = Completer<void>();

    String? config = locator<LocalStorageService>().getString(
      LocalStorageKeys.appConfigurations,
    );

    if (config != null) {
      try {
        _configData = ConfigurationResponseModelDto.fromJsonListString(config)
            .map((ConfigurationResponseModelDto dto) => dto.toDomain())
            .toList();
      } on Object catch (e) {
        log(e.toString());
      }
    }
    // if (_configData?.isNotEmpty ?? false) {
    //   _appConfigCompleter?.complete();
    // }

    Resource<List<ConfigurationResponseModel>?> response =
        await GetConfigurationsUseCase(locator()).execute(NoParams());

    if (response.resourceType == ResourceType.success) {
      _configData = response.data;

      locator<LocalStorageService>().setString(
        LocalStorageKeys.appConfigurations,
        ConfigurationResponseModelDto.toJsonListString(
          (_configData ?? <ConfigurationResponseModel>[])
              .map(ConfigurationResponseModelDto.fromDomain)
              .toList(),
        ),
      );

      if (!(_appConfigCompleter?.isCompleted ?? true)) {
        _appConfigCompleter?.complete();
      }
    }
  }

  @override
  Future<String> get getCatalogVersion async {
    await _appConfigCompleter?.future;
    return _getConfigData(
      key: ConfigurationResponseKeys.catalogBundleCashVersion,
    );
  }

  @override
  String get getDefaultCurrency {
    return _getConfigData(
      key: ConfigurationResponseKeys.defaultCurrency,
    );
  }

  @override
  Future<String> get getSupabaseAnon async {
    String temp =
        _getConfigData(key: ConfigurationResponseKeys.supabaseAnonKey);
    if (temp.isEmpty) {
      await _appConfigCompleter?.future;
      return _getConfigData(key: ConfigurationResponseKeys.supabaseAnonKey);
    }
    return temp;
  }

  @override
  Future<String> get getSupabaseUrl async {
    String temp =
        _getConfigData(key: ConfigurationResponseKeys.supabaseBaseUrl);
    if (temp.isEmpty) {
      await _appConfigCompleter?.future;
      return _getConfigData(key: ConfigurationResponseKeys.supabaseBaseUrl);
    }
    return temp;
  }

  @override
  Future<String> get getWhatsAppNumber async {
    String temp = _getConfigData(key: ConfigurationResponseKeys.whatsAppNumber);
    if (temp.isEmpty) {
      await _appConfigCompleter?.future;
      return _getConfigData(key: ConfigurationResponseKeys.whatsAppNumber);
    }
    return temp;
  }

  @override
  LoginType? get getLoginType {
    String loginTypeString = _getConfigData(
      key: ConfigurationResponseKeys.loginType,
    );
    if (loginTypeString.isNotEmpty) {
      return LoginType.fromValue(value: loginTypeString);
    }
    return null;
  }

  @override
  List<PaymentType>? get getPaymentTypes {
    String paymentTypeString = _getConfigData(
      key: ConfigurationResponseKeys.paymentTypes,
    );
    if (paymentTypeString.isNotEmpty) {
      return PaymentType.getListFromValues(paymentTypeString);
    }
    return null;
  }

  String _getConfigData({required ConfigurationResponseKeys key}) {
    return _configData
            ?.firstWhere(
              (ConfigurationResponseModel element) =>
                  element.key?.toLowerCase() ==
                  key.configurationKeyValue.toLowerCase(),
              orElse: () => ConfigurationResponseModel(key: "", value: ""),
            )
            .value ??
        "";
  }

  @override
  String get getCashbackDiscount {
    String cashbackDiscount = _getConfigData(
      key: ConfigurationResponseKeys.cashbackDiscount,
    );
    return "$cashbackDiscount%";
  }
}
