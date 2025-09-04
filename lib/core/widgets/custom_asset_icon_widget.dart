import 'package:device_tracking_flutter_app/core/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAssetIconWidget extends StatelessWidget {
  final String iconPath;
  const CustomAssetIconWidget({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColor.iconBackgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        height: 44,
        width: 44,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(iconPath),
        ),
      ),
    );
  }
}
