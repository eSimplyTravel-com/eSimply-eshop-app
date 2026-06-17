import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart";
import "package:esim_open_source/data/services/device_info_service_impl.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

/// macOS device-info map used to back the faked platform.
const Map<String, dynamic> _macOsMap = <String, dynamic>{
  "arch": "arm64",
  "model": "Mac16,2",
  "modelName": "iMac",
  "activeCPUs": 8,
  "memorySize": 16,
  "cpuFrequency": 2,
  "hostName": "hostName",
  "osRelease": "osRelease",
  "majorVersion": 14,
  "minorVersion": 0,
  "patchVersion": 0,
  "computerName": "computerName",
  "kernelVersion": "kernelVersion",
  "systemGUID": "guid",
};

/// Linux device-info used to back the faked platform on Linux hosts (CI).
final LinuxDeviceInfo _linuxInfo = LinuxDeviceInfo(
  name: "name",
  id: "id",
  prettyName: "prettyName",
  machineId: "machineId",
);

/// Fake device_info_plus platform returning device info for the current host.
///
/// `DeviceInfoServiceImpl` selects its read path from the real `dart:io`
/// `Platform`, which cannot be overridden in unit tests. The plugin then hard
/// casts the result to the host-specific type (e.g. `linuxInfo` does
/// `... as LinuxDeviceInfo`), so the fake must return a type matching the host
/// or the cast throws. CI runs on Linux while local runs on macOS.
class _FakeDeviceInfoPlatform extends DeviceInfoPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<BaseDeviceInfo> deviceInfo() async {
    if (Platform.isLinux) {
      return _linuxInfo;
    }
    return MacOsDeviceInfo.fromMap(_macOsMap);
  }
}

/// Unit tests for DeviceInfoServiceImpl.
///
/// The service reads device information through device_info_plus and
/// safe_device, both mocked here. The read path is chosen from dart:io
/// `Platform`, which cannot be overridden in unit tests, so initialization
/// follows whichever branch matches the host: `_readMacOsDeviceInfo` locally
/// (macOS) and `_readLinuxDeviceInfo` on CI (Linux). The fake platform returns
/// a host-appropriate device-info type accordingly.
///
/// Platform limitation: the Android / iOS / Windows / Web read paths and their
/// getters are gated by `Platform.isAndroid` / `Platform.isIOS` etc., so they
/// only run on those platforms. Neither the macOS nor the Linux device map
/// carries the boolean keys the `isRooted` / `isPhysicalDevice` /
/// `isDevelopmentModeEnable` / `addDeviceParams` getters expect, so those
/// getters throw on both hosts (asserted below).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel safeDeviceChannel = MethodChannel("safe_device");

  setUp(() {
    DeviceInfoPlatform.instance = _FakeDeviceInfoPlatform();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(safeDeviceChannel, (MethodCall call) async {
      switch (call.method) {
        case "isJailBroken":
          return false;
        case "isDevelopmentModeEnable":
          return false;
        default:
          return false;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(safeDeviceChannel, null);
  });

  group("DeviceInfoServiceImpl", () {
    test("singleton instance is created and reused", () {
      final DeviceInfoServiceImpl instance1 = DeviceInfoServiceImpl.instance;
      final DeviceInfoServiceImpl instance2 = DeviceInfoServiceImpl.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
      expect(instance1, isA<DeviceInfoService>());
    });

    test("deviceData exposes the parsed host device information", () async {
      final DeviceInfoServiceImpl service = DeviceInfoServiceImpl.instance;

      final Map<String, dynamic> data = await service.deviceData;

      if (Platform.isLinux) {
        expect(data["name"], "name");
        expect(data["id"], "id");
        expect(data["prettyName"], "prettyName");
      } else {
        expect(data["computerName"], "computerName");
        expect(data["model"], "Mac16,2");
        expect(data["arch"], "arm64");
      }
    });

    test("deviceInfoPlugin getter resolves to the plugin", () async {
      final DeviceInfoServiceImpl service = DeviceInfoServiceImpl.instance;

      final DeviceInfoPlugin plugin = await service.deviceInfoPlugin;

      expect(plugin, isA<DeviceInfoPlugin>());
    });

    test("deviceID returns empty string on a non-iOS/Android host", () async {
      final DeviceInfoServiceImpl service = DeviceInfoServiceImpl.instance;

      expect(await service.deviceID, "");
    });

    test("isRooted throws on the host where the key is absent", () async {
      final DeviceInfoServiceImpl service = DeviceInfoServiceImpl.instance;

      await expectLater(service.isRooted, throwsA(anything));
    });

    test("isPhysicalDevice throws on the host where the key is absent",
        () async {
      final DeviceInfoServiceImpl service = DeviceInfoServiceImpl.instance;

      await expectLater(service.isPhysicalDevice, throwsA(anything));
    });

    test("isDevelopmentModeEnable throws on the host where the key is absent",
        () async {
      final DeviceInfoServiceImpl service = DeviceInfoServiceImpl.instance;

      await expectLater(service.isDevelopmentModeEnable, throwsA(anything));
    });

    test("addDeviceParams throws on the host where required keys are absent",
        () async {
      final DeviceInfoServiceImpl service = DeviceInfoServiceImpl.instance;

      await expectLater(service.addDeviceParams, throwsA(anything));
    });
  });
}
