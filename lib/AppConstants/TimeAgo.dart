import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

class TimeAgo{
  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime notificationDateTemp = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateString);
    DateTime notificationDate = DateTime(notificationDateTemp.year,notificationDateTemp.month,notificationDateTemp.day,notificationDateTemp.hour,notificationDateTemp.minute,notificationDateTemp.second);
    String notificationDateReturn = DateFormat("dd MMM, yyyy").format(notificationDate.toLocal());
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    print("TIME AGO");
    print(difference.inDays);
    print(difference.inHours);
    print(difference.inMinutes);
    print(difference.inSeconds);
    print("TIME AGO");

    if (difference.inDays > 15) {
      return notificationDateReturn;
    } else if ((difference.inDays / 7) > 1) {
      return (numericDates) ? '2 weeks ago'.tr : '2 weeks ago'.tr;
    } else if ((difference.inDays / 7) == 1) {
      return (numericDates) ? '1 week ago'.tr : 'Last week'.tr;
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} '+'days ago'.tr;
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago'.tr : 'Yesterday'.tr;
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} '+'hours ago'.tr;
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago'.tr : 'An hour ago'.tr;
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} '+'minutes ago'.tr;
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago'.tr : 'A minute ago'.tr;
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} '+'seconds ago'.tr;
    } else {
      return 'Just now'.tr;
    }
  }
}