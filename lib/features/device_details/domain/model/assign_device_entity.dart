class AssignDeviceEntity {
  final int deviceId;
  final int assignedToUserId;
  final int assignedByAdminId;

  AssignDeviceEntity({
    required this.deviceId,
    required this.assignedToUserId,
    required this.assignedByAdminId,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'assigned_to_user_id': assignedToUserId,
      'assigned_by_admin_id': assignedByAdminId,
    };
  }
}
