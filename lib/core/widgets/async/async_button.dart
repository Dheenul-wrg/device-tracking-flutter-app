import 'package:device_tracking_flutter_app/core/widgets/custom_elevated_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncButton extends ConsumerWidget {
  const AsyncButton({
    required this.asyncValue,
    required this.onTap,
    required this.buttonText,
    super.key,
    this.textColor = Colors.white,
    this.iconPath,
    this.buttonColor = Colors.black,
    this.borderColor,
    this.isLoading = false,
    this.horizontalPadding = 30,
    this.loaderColor = Colors.white,
  });

  final AsyncValue asyncValue;
  final VoidCallback? onTap;
  final String buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final String? iconPath;
  final Color? borderColor;
  final bool isLoading;
  final Color loaderColor;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncValue.when(
      data: (data) => buttonBuilder(isLoading: false),
      error: (error, stackTrace) => buttonBuilder(isLoading: false),
      loading: () => buttonBuilder(isLoading: true),
    );
  }

  //TODO: Need to do the complete implementation
  CustomElevatedButton buttonBuilder({required bool isLoading}) {
    return CustomElevatedButton(
      loaderColor: loaderColor,
      buttonText: buttonText,
      onTap: onTap,
      isLoading: isLoading,
      borderColor: borderColor,
      buttonColor: buttonColor,
      horizontalPadding: horizontalPadding,
      iconPath: iconPath,
      textColor: textColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(StringProperty('buttonText', buttonText));
    properties.add(ColorProperty('textColor', textColor));
    properties.add(ColorProperty('buttonColor', buttonColor));
    properties.add(StringProperty('iconPath', iconPath));
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
    properties.add(DiagnosticsProperty<AsyncValue>('asyncValue', asyncValue));
    properties.add(DoubleProperty('horizontalPadding', horizontalPadding));
    properties.add(ColorProperty('loaderColor', loaderColor));
  }
}
