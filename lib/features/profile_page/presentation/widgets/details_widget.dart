import 'package:flutter/material.dart';

import '../../../../core/styles/app_color.dart';
import '../../../../core/styles/app_text_theme.dart';

class DetailsWidget extends StatelessWidget {
  final String leadingText;
  final String trailingText;
  final bool needBottomBorder;
  final BorderRadius? borderRadius;
  const DetailsWidget({
    super.key,
    required this.leadingText,
    required this.trailingText,
    required this.needBottomBorder,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: needBottomBorder
            ? Border(bottom: BorderSide(color: AppColor.dividerColor))
            : Border(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leadingText,
              style: AppTextTheme.getStyle(
                fontType: FontType.mediumTextStyle,
                fontSize: 16,
              ),
            ),
            Text(
              trailingText,
              style: AppTextTheme.getStyle(
                fontType: FontType.regularTextStyle,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
