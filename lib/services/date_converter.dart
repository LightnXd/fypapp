import 'package:intl/intl.dart';

String formatDate(String isoString) {
  final dateTime = DateTime.parse(isoString).toLocal();
  return DateFormat('d MMMM y').format(dateTime);
}

String formatDateTime(String isoString) {
  final dateTime = DateTime.parse(isoString).toLocal();
  return DateFormat('d MMMM y, HH:mm').format(dateTime);
}

String formatTime(String isoString) {
  final dateTime = DateTime.parse(isoString).toLocal();
  return DateFormat('HH:mm').format(dateTime);
}
