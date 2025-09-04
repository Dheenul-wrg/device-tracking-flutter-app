import 'device.dart';

class UserDevice {
  final int trackId;
  final DateTime assignedAt;
  final Device device;

  UserDevice({
    required this.trackId,
    required this.assignedAt,
    required this.device,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      trackId: json['track_id'],
      assignedAt: DateTime.parse(json['assigned_at']),
      device: Device.fromJson(json['device']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'track_id': trackId,
      'assigned_at': assignedAt.toIso8601String(),
      'device': device.toJson(),
    };
  }
}
