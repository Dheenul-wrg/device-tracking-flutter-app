import 'package:device_tracking_flutter_app/core/model/user.dart';

class DeviceHistory {
  final int trackId;
  final DateTime assignedAt;
  final DateTime? unassignedAt;
  final User userDetails;

  DeviceHistory({
    required this.trackId,
    required this.assignedAt,
    required this.unassignedAt,
    required this.userDetails,
  });

  factory DeviceHistory.fromJson(Map<String, dynamic> json) {
    return DeviceHistory(
      trackId: json['track_id'],
      assignedAt: DateTime.parse(json['assigned_at']),
      unassignedAt: json['unassigned_at'] != null
          ? DateTime.parse(json['unassigned_at'])
          : null,
      userDetails: User.fromJson(json['user_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'track_id': trackId,
      'assigned_at': assignedAt.toIso8601String(),
      'unassigned_at': unassignedAt?.toIso8601String(),
      'user_details': userDetails.toJson(),
    };
  }
}
