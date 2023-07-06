import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateFormatUtils {

  /// 日期格式化，dayOnly：只展示到天
  static String format(int millisecondsSinceEpoch,{bool dayOnly = true}) {
    // 获取当前日期
    DateTime nowDate = getZhCurrentDateTime();
    debugPrint('打印Now日期时间：${DateFormat('yyyy年M月d日 HH:mm:ss').format(nowDate)}');
    // 传入的日期
    DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    debugPrint('打印target日期时间：${DateFormat('yyyy年M月d日 HH:mm:ss').format(targetDate)}');
    String prefix = "";
    if(nowDate.year != targetDate.year) {
      prefix = DateFormat('yyyy年M月d日').format(targetDate);
    } else if(nowDate.month != targetDate.month) {
      prefix = DateFormat('M月d日').format(targetDate);
    } else if(nowDate.day != targetDate.day) {
      if(nowDate.day - targetDate.day == 1) {
        //昨天
        prefix = "昨天";
      } else {
        prefix = DateFormat('M月d日').format(targetDate);
      }
    }

    if(prefix.isNotEmpty && dayOnly) {
      return prefix;
    }
    String suffix = DateFormat('HH:mm').format(targetDate);
    return '$prefix $suffix';

  }

  static DateTime getZhCurrentDateTime(){
    return DateTime.now().toUtc().add(const Duration(hours: 8));
  }
  static int getZhCurrentTimeMilliseconds(){
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }
}