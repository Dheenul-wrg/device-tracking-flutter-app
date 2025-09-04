import 'package:device_tracking_flutter_app/core/model/device_history.dart';

class MobileInfo {
  final int id;
  final int deviceId;
  final String serialNumber;
  final String platform;
  final String brand;
  final String model;
  final String macAddress;
  final String imeiNumber;
  final String deviceName;
  final List<DeviceHistory> deviceHistory;

  MobileInfo({
    required this.id,
    required this.deviceId,
    required this.serialNumber,
    required this.platform,
    required this.brand,
    required this.model,
    required this.macAddress,
    required this.imeiNumber,
    required this.deviceName,
    required this.deviceHistory,
  });

  factory MobileInfo.fromJson(Map<String, dynamic> json) {
    return MobileInfo(
      id: json['id'],
      deviceId: json['device_id'],
      serialNumber: json['serial_number'],
      platform: json['platform'],
      brand: json['brand'],
      model: json['model'],
      macAddress: json['mac_address'],
      imeiNumber: json['imei_number'],
      deviceName: json['device_name'],
      deviceHistory:
          (json['device_history'] as List<dynamic>?)
              ?.map((e) => DeviceHistory.fromJson(e))
              .toList() ??
          [],
    );
  }

  static List<MobileInfo> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => MobileInfo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'serial_number': serialNumber,
      'platform': platform,
      'brand': brand,
      'model': model,
      'mac_address': macAddress,
      'imei_number': imeiNumber,
      'device_name': deviceName,
      'device_history': deviceHistory.map((e) => e.toJson()).toList(),
    };
  }

  MobileInfo copyWith({
    int? id,
    int? deviceId,
    String? serialNumber,
    String? platform,
    String? brand,
    String? model,
    String? macAddress,
    String? imeiNumber,
    String? deviceName,
    List<DeviceHistory>? deviceHistory,
  }) {
    return MobileInfo(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      serialNumber: serialNumber ?? this.serialNumber,
      platform: platform ?? this.platform,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      macAddress: macAddress ?? this.macAddress,
      imeiNumber: imeiNumber ?? this.imeiNumber,
      deviceName: deviceName ?? this.deviceName,
      deviceHistory: deviceHistory ?? this.deviceHistory,
    );
  }
}
