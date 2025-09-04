class UserTrackingHistory {
  final int deviceTrackingId;
  final DateTime loggedInAt;
  final DateTime? loggedOutAt;

  UserTrackingHistory({
    required this.deviceTrackingId,
    required this.loggedInAt,
    required this.loggedOutAt,
  });

  factory UserTrackingHistory.fromJson(Map<String, dynamic> json) {
    return UserTrackingHistory(
      deviceTrackingId: json['device_tracking_id'],
      loggedInAt: DateTime.parse(json['logged_in_at']),
      loggedOutAt: json['logged_out_at'] != null
          ? DateTime.tryParse(json['logged_out_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_tracking_id': deviceTrackingId,
      'logged_in_at': loggedInAt.toIso8601String(),
      'logged_out_at': loggedOutAt?.toIso8601String(),
    };
  }
}
