import 'package:bubble/bubble.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/util/wechat_date_format.dart';
import 'package:flutter/material.dart';

typedef MessageWidgetBuilder = Widget Function(MessageModel messageModel);
typedef OnBubbleClick = void Function(MessageModel messageModel, BuildContext ancestor);

class DefaultMessageWidget extends StatelessWidget {
  final MessageModel messageModel;
  final String? fontFamily;
  final double fontSize;
  final double avatarSize;
  final Color? textColor;
  final Color? backgroundColor;
  final MessageWidgetBuilder? messageWidget;
  final OnBubbleClick? onBubbleTap;
  final OnBubbleClick? onBubbleLongPress;

  const DefaultMessageWidget({
    required GlobalKey key,
    required this.messageModel,
    this.fontFamily,
    this.fontSize = 12,
    this.avatarSize = 28,
    this.textColor,
    this.backgroundColor,
    this.messageWidget,
    this.onBubbleTap,
    this.onBubbleLongPress,
  }) : super(key: key);

  Widget get _buildCircleAvatar {
    var child = messageModel.avatar is String
        ? ClipOval(
            child: Image.network(
            messageModel.avatar!,
            height: avatarSize,
            width: avatarSize,
          ))
        : CircleAvatar(
            radius: 20,
            child: Text(senderInitials, style: const TextStyle(fontSize: 16)),
          );
    return child;
  }

  String get senderInitials {
    if (messageModel.ownerName == null) return "";
    List<String> chars = messageModel.ownerName!.split(" ");
    if (chars.length > 1) {
      return chars[0];
    } else {
      return messageModel.ownerName![0];
    }
  }

  double? get contentMargin => avatarSize + 10;

  @override
  Widget build(BuildContext context) {
    if (messageWidget != null) return messageWidget!(messageModel);
    Widget content = messageModel.ownerType == OwnerType.receiver ? _buildReceiver(context) : _buildSender(context);
    return Column(
      children: [
        if (messageModel.showCreatedTime) _buildCreatedTime(),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: content,
        )
      ],
    );
  }

  /// 接收方 - 机器人
  _buildReceiver(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 6),
          child: _buildCircleAvatar,
        ),
        // 宽度撑满
        Flexible(
            child: Bubble(
          margin: BubbleEdges.fromLTRB(2, 0, contentMargin, 0),
          stick: true,
          nip: BubbleNip.leftTop,
          color: backgroundColor ?? const Color.fromARGB(233, 233, 252, 19),
          alignment: Alignment.topLeft,
          child: _buildContentText(TextAlign.left, context),
        ))
      ],
    );
  }

  /// 发送方 - 使用者
  _buildSender(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 宽度撑满
        Flexible(
            child: Bubble(
          margin: BubbleEdges.fromLTRB(contentMargin, 0, 2, 0),
          stick: true,
          nip: BubbleNip.rightTop,
          color: backgroundColor ?? Colors.white,
          alignment: Alignment.topRight,
          child: _buildContentText(TextAlign.left, context),
        )),
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: _buildCircleAvatar,
        ),
      ],
    );
  }

  _buildContentText(TextAlign align, BuildContext context) {
    return InkWell(
      onTap: () => onBubbleTap != null ? onBubbleTap!(messageModel, context) : null,
      onLongPress: () => onBubbleLongPress != null ? onBubbleLongPress!(messageModel, context) : null,
      child: Text(
        messageModel.content,
        textAlign: align,
        style: TextStyle(fontSize: fontSize, color: textColor ?? Colors.black87, fontFamily: fontFamily),
      ),
    );
  }

  _buildCreatedTime() {
    String showTime = WechatDateFormat.format(messageModel.createdAt, dayOnly: false);
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: Text(showTime),
    );
  }
}
