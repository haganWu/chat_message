import 'package:flutter/cupertino.dart';

enum OwnerType { receiver, sender }

/// 枚举 - String 转换
OwnerType _of(String name) {
  if (name == OwnerType.receiver.toString()) {
    return OwnerType.receiver;
  } else {
    return OwnerType.sender;
  }
}

class MessageModel {
  final int? id;
  // 避免添加数据的时候重新刷新问题
  final GlobalKey key;
  // 消息发送方/接收方标识，用于决定消息展示在哪一侧
  final OwnerType ownerType;
  // 消息发送方姓名
  final String? ownerName;
  // 头像URL
  final String? avatar;
  // 内容
  final String content;

  // 时间
  final int createdAt;

  // 是否展示创建时间
  bool showCreatedTime;

  MessageModel({this.id, required this.ownerType, this.ownerName, this.avatar, required this.content, required this.createdAt, this.showCreatedTime = false}) : key = GlobalKey();

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(ownerType: _of(json['ownerType']), content: json['content'], createdAt: json['createAt'], ownerName: json['ownerName'], avatar: json['avatar'], id: json['id']);

  Map<String, dynamic> toJSon() => {
        'id': id,
        'ownerType': ownerType.toString(),
        'content': content,
        'createAt': createdAt,
        'ownerName': ownerName,
        'avatar': avatar,
      };
}
