// repositories/home_data_repository.dart
import "dart:developer";

import "package:esim_open_source/data/data_source/home_data_entities/bundle_type.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_bundle_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_country_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/transaction_history_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/transaction_history_response_model_dto.dart";
import "package:esim_open_source/objectbox.g.dart";

class EsimsLocalDataSource {
  EsimsLocalDataSource(this._store)
      : _esimBox = _store.box<EsimEntity>(),
        _countryBox = _store.box<EsimCountryEntity>(),
        _bundleCategoryBox = _store.box<EsimBundleCategoryEntity>();

  final Store _store;
  final Box<EsimEntity> _esimBox;
  final Box<EsimCountryEntity> _countryBox;
  final Box<EsimBundleCategoryEntity> _bundleCategoryBox;

  Future<void> replacePurchasedEsims(
    List<PurchaseEsimBundleResponseModelDto>? dataList,
  ) async {
    if (dataList == null) {
      return;
    }
    clearCache();
    _store.runInTransaction(TxMode.write, () {
      for (final PurchaseEsimBundleResponseModelDto data in dataList) {
        final EsimEntity esimData = _createEsimEntity(data);
        _esimBox.put(esimData);
      }
    });

    log("Purchased Esim Saved to db");
  }

  EsimEntity _createEsimEntity(PurchaseEsimBundleResponseModelDto data) {
    final EsimEntity esimData = EsimEntity.fromModel(data);
    _attachBundleCategory(esimData, data.bundleCategory);
    _attachCountries(esimData, data.countries);
    _attachTransactionHistory(esimData, data.transactionHistory);
    return esimData;
  }

  void _attachBundleCategory(
    EsimEntity esimData,
    dynamic bundleCategory,
  ) {
    if (bundleCategory != null) {
      final EsimBundleCategoryEntity categoryEntity =
          EsimBundleCategoryEntity.fromModel(bundleCategory);
      esimData.bundleCategory.target = categoryEntity;
    }
  }

  void _attachCountries(
    EsimEntity esimData,
    List<CountryResponseModelDto>? countries,
  ) {
    if (countries == null) {
      return;
    }
    for (final CountryResponseModelDto country in countries) {
      final EsimCountryEntity countryEntity =
          EsimCountryEntity.fromModel(country);
      esimData.countries.add(countryEntity);
    }
  }

  void _attachTransactionHistory(
    EsimEntity esimData,
    List<TransactionHistoryResponseModelDto>? transactionHistory,
  ) {
    if (transactionHistory == null) {
      return;
    }
    for (final TransactionHistoryResponseModelDto transaction
        in transactionHistory) {
      final TransactionHistoryEntity transactionEntity =
          _createTransactionEntity(transaction);
      esimData.transactionHistory.add(transactionEntity);
    }
  }

  TransactionHistoryEntity _createTransactionEntity(
    TransactionHistoryResponseModelDto transaction,
  ) {
    final TransactionHistoryEntity transactionEntity =
        TransactionHistoryEntity.fromModel(transaction);

    if (transaction.bundle != null) {
      final EsimBundleEntity bundleEntity = _createBundleEntity(
        transaction.bundle!,
      );
      transactionEntity.bundle.target = bundleEntity;
    }

    return transactionEntity;
  }

  EsimBundleEntity _createBundleEntity(dynamic bundle) {
    final EsimBundleEntity bundleEntity = EsimBundleEntity.fromModel(
      bundle,
      BundleType.global,
    );

    _attachBundleCategoryToBundle(bundleEntity, bundle.bundleCategory);
    _attachCountriesToBundle(bundleEntity, bundle.countries);

    return bundleEntity;
  }

  void _attachBundleCategoryToBundle(
    EsimBundleEntity bundleEntity,
    dynamic bundleCategory,
  ) {
    if (bundleCategory != null) {
      final EsimBundleCategoryEntity categoryEntity =
          EsimBundleCategoryEntity.fromModel(bundleCategory);
      _bundleCategoryBox.put(categoryEntity);
      bundleEntity.bundleCategory.target = categoryEntity;
    }
  }

  void _attachCountriesToBundle(
    EsimBundleEntity bundleEntity,
    List<CountryResponseModelDto>? countries,
  ) {
    if (countries == null) {
      return;
    }
    for (final CountryResponseModelDto country in countries) {
      final EsimCountryEntity countryEntity = _findOrCreateCountry(country);
      bundleEntity.countries.add(countryEntity);
    }
  }

  EsimCountryEntity _findOrCreateCountry(CountryResponseModelDto country) {
    final EsimCountryEntity? existingCountry = _countryBox
        .query(EsimCountryEntity_.iso3Code.equals(country.iso3Code ?? ""))
        .build()
        .findFirst();

    if (existingCountry != null) {
      return existingCountry;
    }

    final EsimCountryEntity newCountry = EsimCountryEntity.fromModel(country);
    _countryBox.put(newCountry);
    return newCountry;
  }

  List<PurchaseEsimBundleResponseModelDto>? getPurchasedEsims() {
    final List<EsimEntity> esimData = _esimBox.query().build().find();
    log("Purchased Esim from db count ${esimData.length}");
    return esimData.map((EsimEntity esim) => esim.toModel()).toList();
  }

  Future<void> clearCache() async {
    _store.runInTransaction(TxMode.write, () {
      _esimBox.removeAll();
      _countryBox.removeAll();
      _bundleCategoryBox.removeAll();
    });
  }
}
