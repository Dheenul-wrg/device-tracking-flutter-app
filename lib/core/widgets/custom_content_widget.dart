import 'package:device_tracking_flutter_app/core/styles/app_text_theme.dart';
import 'package:flutter/material.dart';

class CustomContentWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  const CustomContentWidget({super.key, required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.getStyle(
            fontType: FontType.mediumTextStyle,
            fontSize: 16,
          ),
        ),
        if (subTitle != null)
          Text(
            subTitle!,
            style: AppTextTheme.getStyle(fontType: FontType.regularTextStyle),
          ),
      ],
    );
  }
}
