class UserLoginTrackEntity {
  final int userId;
  final int deviceId;

  UserLoginTrackEntity({required this.userId, required this.deviceId});

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'device_id': deviceId};
  }
}
