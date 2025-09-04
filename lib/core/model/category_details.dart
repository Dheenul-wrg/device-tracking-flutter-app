import 'package:device_tracking_flutter_app/core/assets_data/app_icons.dart';

class CategoryDetails {
  final int id;
  final String name;
  final CategoryImage categoryImage;
  final int? deviceCount;

  CategoryDetails({required this.id, required this.name, this.deviceCount})
    : categoryImage = _mapNameToImage(name);

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? json['category_name'] as String;
    return CategoryDetails(
      id: json['id'] ?? json['category_id'] as int,
      name: name,
      deviceCount: json['device_count'] != null
          ? int.tryParse(json['device_count'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (deviceCount != null) 'device_count': deviceCount,
      // optional: 'categoryImage': categoryImage.assetPath,
    };
  }

  static List<CategoryDetails> fromJsonToList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CategoryDetails.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static CategoryImage _mapNameToImage(String name) {
    switch (name.toLowerCase()) {
      case 'mobile':
        return CategoryImage.mobile;
      case 'laptop':
        return CategoryImage.laptop;
      case 'tablet':
        return CategoryImage.tablet;
      case 'desktop' || 'monitor':
        return CategoryImage.desktop;
      default:
        return CategoryImage.unknown;
    }
  }
}

enum CategoryImage {
  mobile(AppIcons.mobileIcon),
  laptop(AppIcons.laptopIcon),
  tablet(AppIcons.tabletIcon),
  desktop(AppIcons.desktopIcon),
  unknown(AppIcons.errorIcon);

  final String assetPath;
  const CategoryImage(this.assetPath);
}
