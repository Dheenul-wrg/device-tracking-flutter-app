import 'category_details.dart';
import 'mobile_info.dart';

class Device {
  final int id;
  final DateTime createdAt;
  final CategoryDetails categoryDetails;
  final MobileInfo mobileInfo;

  Device({
    required this.id,
    required this.createdAt,
    required this.categoryDetails,
    required this.mobileInfo,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      categoryDetails: CategoryDetails.fromJson(json['category_details']),
      mobileInfo: MobileInfo.fromJson(json['mobile_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'category_details': categoryDetails.toJson(),
      'mobile_info': mobileInfo.toJson(),
    };
  }
}
