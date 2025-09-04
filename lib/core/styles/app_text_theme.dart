import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum FontType {
  regularTextStyle,
  boldTextStyle,
  mediumTextStyle,
  semiBoldTextStyle,
  primaryTitleTextStyle,
  secondaryTitleTextStyle,
  largeTitleTextStyle,
  primarySubTitleTextStyle,
  secondarySubTitleTextStyle,
  hintTextStyle,
  primaryLabelTextStyle,
  secondaryLabelTextStyle,
}

class AppTextTheme {
  AppTextTheme._();
  static TextStyle getStyle({
    required FontType fontType,
    double fontSize = 14,
    Color textColor = Colors.black,
  }) {
    switch (fontType) {
      case FontType.regularTextStyle:
        return TextStyle(
          height: 1.5,
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.w400,
          ).fontFamily,
        );
      case FontType.mediumTextStyle:
        return TextStyle(
          height: 1.5,
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.w500,
          ).fontFamily,
        );
      case FontType.boldTextStyle:
        return TextStyle(
          height: 1.5,
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
          ).fontFamily,
        );
      case FontType.semiBoldTextStyle:
        return TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
          ).fontFamily,
        );
      case FontType.primaryTitleTextStyle:
        return TextStyle(
          height: 1,
          letterSpacing: 0,
          fontSize: 32,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
          ).fontFamily,
        );
      case FontType.secondaryTitleTextStyle:
        return TextStyle(
          height: 1,
          letterSpacing: 0,
          fontSize: 32,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
          ).fontFamily,
        );
      case FontType.largeTitleTextStyle:
        return TextStyle(
          height: 1,
          letterSpacing: 0,
          fontSize: 48,
          color: textColor,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
          ).fontFamily,
        );
      case FontType.primarySubTitleTextStyle:
        return TextStyle(
          height: 1.5,
          letterSpacing: 0,
          fontSize: 18,
          color: textColor,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
          ).fontFamily,
        );
      case FontType.secondarySubTitleTextStyle:
        return TextStyle(
          height: 1.5,
          letterSpacing: 0,
          fontSize: 18,
          color: textColor,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
          ).fontFamily,
        );
      case FontType.hintTextStyle:
        return TextStyle(
          fontSize: fontSize,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.w400,
          ).fontFamily,
        );
      case FontType.primaryLabelTextStyle:
        return TextStyle(
          fontSize: 12,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.w500,
          ).fontFamily,
        );
      case FontType.secondaryLabelTextStyle:
        return TextStyle(
          fontSize: 12,
          fontFamily: GoogleFonts.raleway(
            fontWeight: FontWeight.w500,
          ).fontFamily,
        );
    }
  }
}
