import '../enums/role.dart';
import 'user_device.dart';

class User {
  final int userId;
  final String userName;
  final String userEmail;
  final String userMobileNumber;
  final Role? role;
  final List<UserDevice> assignedDevices;

  User({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userMobileNumber,
    required this.role,
    required this.assignedDevices,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      userName: json['name'],
      userEmail: json['email'],
      userMobileNumber: json['mobile_number'],
      role: json.containsKey('role')
          ? Role.fromValue(json['role'])
          : Role.unknownRole,
      assignedDevices:
          (json['assigned_devices'] as List<dynamic>?)
              ?.map((e) => UserDevice.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': userName,
      'email': userEmail,
      'mobile_number': userMobileNumber,
      'role': role?.value,
      'assigned_devices': assignedDevices.map((e) => e.toJson()).toList(),
    };
  }

  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
