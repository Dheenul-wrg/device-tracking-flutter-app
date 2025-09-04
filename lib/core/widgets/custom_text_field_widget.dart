import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../styles/app_text_theme.dart';

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget({
    required this.labelText,
    required this.controller,
    required this.hintText,
    super.key,
    this.borderColor = Colors.black,
    this.labelTextStyle,
    this.bottomSpacing = 20,
    this.topSpacing = 20,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.isReadOnly = false,
    this.onChanged,
    this.onEditingComplete,
    this.suffixIcon,
    this.errorText,
  });

  final String labelText;
  final TextEditingController? controller;
  final Color? borderColor;
  final String? hintText;
  final String? errorText;
  final TextStyle? labelTextStyle;
  final TextInputType? keyboardType;
  final double bottomSpacing;
  final double topSpacing;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final bool isReadOnly;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('labelText', labelText));
    properties.add(
      DiagnosticsProperty<TextEditingController?>('controller', controller),
    );
    properties.add(ColorProperty('borderColor', borderColor));
    properties.add(StringProperty('hintText', hintText));
    properties.add(
      DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType),
    );
    properties.add(DoubleProperty('bottomSpacing', bottomSpacing));
    properties.add(
      ObjectFlagProperty<FormFieldValidator<String>?>.has(
        'validator',
        validator,
      ),
    );
    properties.add(
      EnumProperty<TextCapitalization?>(
        'textCapitalization',
        textCapitalization,
      ),
    );
  }
}

class _CustomTextFieldState extends State<CustomTextFieldWidget> {
  final bool _hideText = false;

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      readOnly: widget.isReadOnly,
      controller: widget.controller,
      onTapOutside: _unfocusTextField,
      cursorColor: Colors.black,
      obscureText: _hideText,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      validator: widget.validator,
      style: AppTextTheme.getStyle(fontType: FontType.regularTextStyle),
      onChanged: (value) => widget.onChanged?.call(value),
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        errorMaxLines: 2,
        counterText: '',
        hintText: widget.hintText,
        hintStyle: AppTextTheme.getStyle(fontType: FontType.hintTextStyle),
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        errorText: widget.errorText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.black,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: widget.suffixIcon,
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.bottomSpacing,
        top: widget.topSpacing,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 300, maxWidth: 450),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            widget.isReadOnly ? IgnorePointer(child: textField) : textField,
            Positioned(
              left: 16,
              top: -12,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6, right: 6),
                  child: Text(
                    widget.labelText,
                    style:
                        widget.labelTextStyle ??
                        AppTextTheme.getStyle(
                          fontType: FontType.secondaryLabelTextStyle,
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

void _unfocusTextField(PointerDownEvent value) {
  FocusManager.instance.primaryFocus?.unfocus();
}
