import 'package:intl/intl.dart';

String formatDate(String isoString) {
  final dateTime = DateTime.parse(isoString);
  return DateFormat('d MMMM y').format(dateTime); // e.g., 1 January 2024
}

String formatDateTime(String isoString) {
  final dateTime = DateTime.parse(isoString);
  return DateFormat(
    'd MMMM y, HH:mm',
  ).format(dateTime); // e.g., 1 January 2024, 08:48
}

String formatTime(String isoString) {
  final dateTime = DateTime.parse(isoString);
  return DateFormat('HH:mm').format(dateTime); // e.g., 08:48
}
