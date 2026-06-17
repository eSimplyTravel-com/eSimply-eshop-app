class DeviceInfoRequestModel {
  DeviceInfoRequestModel({
    required this.deviceName,
    this.latitude = 0,
    this.longitude = 0,
    this.mcc = "0",
    this.mnc = "0",
  });

  String deviceName;
  double latitude;
  double longitude;
  String mcc;
  String mnc;
}
