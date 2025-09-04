import 'dart:ui';

class ListItemDetail {
  final String title;
  final String content;
  final VoidCallback? onTap;

  ListItemDetail({required this.title, required this.content, this.onTap});
}
