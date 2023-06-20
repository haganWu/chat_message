import 'package:intl/intl.dart';

class WechatDateFormat {

  /// 日期格式化，dayOnly：只展示到天
  static String format(int millisecondsSinceEpoch,{bool dayOnly = true}) {
    // 获取当前日期
    DateTime nowDate = DateTime.now();
    // 传入的日期
    DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
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

    int targetHour = targetDate.hour;
    String returnTime = "", suffix = DateFormat('h:mm').format(targetDate);
    if(targetHour >= 0 && targetHour < 6) {
      returnTime = '凌晨';
    } else if(targetHour >= 6 && targetHour < 8) {
      returnTime = '早晨';
    } else if(targetHour >= 8 && targetHour < 11) {
      returnTime = '上午';
    } else if(targetHour >= 11 && targetHour < 13) {
      returnTime = '中午';
    } else if(targetHour >= 13 && targetHour < 18) {
      returnTime = '下午';
    } else if(targetHour >= 18 && targetHour < 23) {
      returnTime = '晚上';
    }

    return '$prefix $returnTime$suffix';

  }
}