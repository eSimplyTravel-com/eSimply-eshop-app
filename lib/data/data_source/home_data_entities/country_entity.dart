// entities/country_entity.dart
import "package:esim_open_source/data/data_source/home_data_entities/bundle_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:objectbox/objectbox.dart";

@Entity()
class CountryEntity {
  CountryEntity({
    required this.countryID,
    required this.country,
    required this.iso3Code,
    required this.zoneName,
    required this.countryCode,
    required this.alternativeCountry,
    required this.icon,
    required this.operatorList,
  });

  factory CountryEntity.fromModel(CountryResponseModelDto model) {
    return CountryEntity(
      countryID: model.id,
      country: model.country,
      iso3Code: model.iso3Code,
      zoneName: model.zoneName,
      countryCode: model.countryCode,
      alternativeCountry: model.alternativeCountry,
      icon: model.icon,
      operatorList: model.operatorList,
    );
  }
  @Id()
  int id = 0;

  final String? countryID;
  final String? country;
  final String? iso3Code;
  final String? zoneName;
  final String? countryCode;
  final String? icon;
  final List<String>? operatorList;

  String? alternativeCountry;

  final ToMany<BundleEntity> bundles = ToMany<BundleEntity>();

  CountryResponseModelDto toModel() {
    return CountryResponseModelDto(
      id: countryID,
      country: country,
      iso3Code: iso3Code,
      zoneName: zoneName,
      countryCode: countryCode,
      alternativeCountry: alternativeCountry,
      icon: icon,
      operatorList: operatorList,
    );
  }
}
