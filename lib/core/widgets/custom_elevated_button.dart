import 'package:device_tracking_flutter_app/core/styles/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.onTap,
    this.buttonText,
    super.key,
    this.textColor = Colors.white,
    this.iconPath,
    this.buttonColor = Colors.black,
    this.borderColor,
    this.isLoading = false,
    this.horizontalPadding = 0,
    this.iconData,
    this.loaderColor = Colors.white,
  });
  final VoidCallback? onTap;
  final String? buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final String? iconPath;
  final Color? borderColor;
  final bool isLoading;
  final Color loaderColor;
  final double horizontalPadding;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 20, maxWidth: 500),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
                  foregroundColor: textColor,
                  backgroundColor: buttonColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  side: BorderSide(
                    color: borderColor ?? buttonColor ?? Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ).copyWith(
                  elevation: WidgetStateProperty.resolveWith<double>((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return 4;
                    }
                    return 4;
                  }),
                ),
            onPressed: () {
              if (isLoading) {
                return;
              }
              onTap?.call();
            },
            child: Center(
              child: Stack(
                children: [
                  Visibility(
                    visible: !isLoading,
                    replacement: LoadingAnimationWidget.progressiveDots(
                      color: loaderColor,
                      size: 50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (iconData != null)
                          Icon(iconData, color: Colors.white),
                        if (iconPath != null)
                          SvgPicture.asset(iconPath!, width: 50, height: 50),
                        if (iconPath != null) const SizedBox(width: 16),
                        if (buttonText != null)
                          Text(
                            buttonText!,
                            style: AppTextTheme.getStyle(
                              fontType: FontType.semiBoldTextStyle,
                              fontSize: 18,
                              textColor: Colors.white,
                            ),
                            // style: TextStyle(
                            //   fontWeight: FontWeight.w600,
                            //   fontSize: 16,
                            //   color: textColor ?? Colors.white,
                            // ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
