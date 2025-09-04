import 'package:flutter/material.dart';

class CustomDropDownWidget<T> extends StatelessWidget {
  const CustomDropDownWidget({
    super.key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.width = 80,
    this.borderRadius = 15,
    this.dropdownColor = Colors.white,
    this.labelStyle = const TextStyle(color: Colors.black),
  });

  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T>? validator;
  final double width;
  final double borderRadius;
  final Color dropdownColor;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T>(
        value: value,
        validator: validator, // 🧩 Added validator here
        borderRadius: BorderRadius.circular(borderRadius),
        dropdownColor: dropdownColor,
        decoration: InputDecoration(
          fillColor: Colors.white,
          labelText: labelText,
          floatingLabelStyle: labelStyle,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
