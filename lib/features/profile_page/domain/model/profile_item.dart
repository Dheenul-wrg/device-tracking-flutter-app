import 'package:flutter/widgets.dart';

class ProfileItem {
  final String title;
  final String data;
  final VoidCallback? opTap;

  ProfileItem({required this.title, required this.data, this.opTap});
}
