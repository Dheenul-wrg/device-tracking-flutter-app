class NewMobileEntity {
  final String serialNumber;
  final String platform;
  final String brand;
  final String model;
  final String macAddress;
  final String imeiNumber;
  final String deviceName;

  NewMobileEntity({
    required this.serialNumber,
    required this.platform,
    required this.brand,
    required this.model,
    required this.macAddress,
    required this.imeiNumber,
    required this.deviceName,
  });

  Map<String, dynamic> toJson() {
    return {
      'serial_number': serialNumber,
      'platform': platform,
      'brand': brand,
      'model': model,
      'mac_address': macAddress,
      'imei_number': imeiNumber,
      'device_name': deviceName,
    };
  }
}
