import 'package:chat_message/util/date_format_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('wechat date format', () {
    debugPrint(DateFormatUtils.format(DateTime.parse('2021-06-18 09:18:18').millisecondsSinceEpoch,dayOnly: false).toString());
  });
}
