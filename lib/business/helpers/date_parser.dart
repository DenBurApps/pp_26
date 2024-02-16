import 'package:pp_26/business/helpers/month_enum.dart';

class DateParser {
  static String parseDate({required DateTime dateTime}) {
    if (dateTime.month == DateTime.now().month && dateTime.day == DateTime.now().day) {
      if (dateTime.hour > 12) {
        return 'Today at ${dateTime.hour}:${dateTime.minute} pm';
      } else {
        return 'Today at ${dateTime.hour}:${dateTime.minute} am';
      }
    }
    if (dateTime.hour > 12) {
      return '${DateHelper.months[dateTime.month]} ${dateTime.day} at ${dateTime.hour}:${dateTime.minute} pm';
    } else {
      return '${DateHelper.months[dateTime.month]} ${dateTime.day} at ${dateTime.hour}:${dateTime.minute} am';
    }
  }
}
