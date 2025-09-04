import 'package:flutter/material.dart';

import '../../../core/styles/app_text_theme.dart'; // Update the import as needed

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool centerTitle;
  final TextStyle? titleTextStyle;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.centerTitle = false,
    this.titleTextStyle,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      title: Text(
        title,
        style:
            titleTextStyle ??
            AppTextTheme.getStyle(
              fontType: FontType.boldTextStyle,
              fontSize: 24,
            ),
      ),
      centerTitle: centerTitle,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: actions,
    );
  }
}
