import 'package:device_tracking_flutter_app/core/styles/app_color.dart';
import 'package:device_tracking_flutter_app/core/styles/app_text_theme.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_asset_icon_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_content_widget.dart';
import 'package:flutter/material.dart';

class CustomListItemWidget extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String? leadingIcon;
  final String title;
  final String? subTitle;
  final String? trailingContent;
  final Widget? trailingOnTap;
  final VoidCallback? onTap;

  const CustomListItemWidget({
    super.key,
    required this.isFirst,
    required this.isLast,
    this.leadingIcon,
    required this.title,
    this.subTitle,
    this.trailingOnTap,
    this.trailingContent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(8) : Radius.zero,
          topRight: isFirst ? Radius.circular(8) : Radius.zero,
          bottomLeft: isLast ? Radius.circular(8) : Radius.zero,
          bottomRight: isLast ? Radius.circular(8) : Radius.zero,
        ),
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: AppColor.dividerColor),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: leadingIcon == null ? 14 : 16,
        ),
        child: Row(
          children: [
            if (leadingIcon != null)
              CustomAssetIconWidget(iconPath: leadingIcon!),
            if (leadingIcon != null) const SizedBox(width: 16),
            CustomContentWidget(title: title, subTitle: subTitle),
            if (trailingOnTap != null) trailingOnTap!,
            Spacer(),
            if (trailingContent != null)
              Text(
                trailingContent!,
                style: AppTextTheme.getStyle(
                  fontType: FontType.regularTextStyle,
                  textColor: AppColor.trailingTextColor,
                ),
              ),
            if (onTap != null)
              Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        left: 4,
                        right: 4,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColor.dividerColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
