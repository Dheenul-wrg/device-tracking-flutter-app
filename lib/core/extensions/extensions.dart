import 'package:intl/intl.dart';

extension FormattedDateTime on DateTime {
  String toFormattedString() {
    final dayFormat = DateFormat('EEE'); // e.g., Tue
    final dateFormat = DateFormat('d MMM y'); // e.g., 8 Jul 2025
    final timeFormat = DateFormat('h:mm a'); // e.g., 10:57 AM

    return '${dayFormat.format(this)}, ${dateFormat.format(this)} – ${timeFormat.format(this)}';
  }
}
