import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatShort(DateTime date) {
    return DateFormat('EEE, d MMM').format(date); // contoh: Wed, 2 Aug
  }
}
