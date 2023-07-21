import 'package:intl/intl.dart';

class DateFormatUtils {
  /// 日期格式化，dayOnly：只展示到天
  static String format(int millisecondsSinceEpoch, {bool dayOnly = true}) {
    if (millisecondsSinceEpoch <= 0) return '';
    // 获取当前日期
    DateTime nowDate = getZhCurrentDateTime();
    // 传入的日期
    DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String prefix = "";
    if (nowDate.year != targetDate.year) {
      prefix = DateFormat('yyyy年M月d日').format(targetDate);
    } else if (nowDate.month != targetDate.month) {
      prefix = DateFormat('M月d日').format(targetDate);
    } else if (nowDate.day != targetDate.day) {
      if (nowDate.day - targetDate.day == 1) {
        //昨天
        prefix = "昨天";
      } else {
        prefix = DateFormat('M月d日').format(targetDate);
      }
    }

    if (prefix.isNotEmpty && dayOnly) {
      return prefix;
    }
    String suffix = DateFormat('HH:mm').format(targetDate);
    return '$prefix $suffix';
  }

  /// 格式化日期时间：6/18 13:33
  static String formatYMd(int millisecondsSinceEpoch) {
    DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('M/d h:mm').format(targetDate);
  }

  static DateTime getZhCurrentDateTime() {
    return DateTime.now().toUtc().add(const Duration(hours: 8));
  }

  static int getZhCurrentTimeMilliseconds() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }
}
