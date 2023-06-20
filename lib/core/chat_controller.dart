import 'dart:async';

import 'package:chat_message/models/message_model.dart';
import 'package:flutter/widgets.dart';

class ChatController implements IChatController {
  // 初始化数据
  final List<MessageModel> initialMessageList;
  final ScrollController scrollController;

  // 展示时间间隔,单位:秒
  final int timePellet;
  List<int> pelletShow = [];

  ChatController({required this.initialMessageList, required this.scrollController, required this.timePellet}){
    for(var message in initialMessageList.reversed) {
      inflateMessage(message);
    }
  }

  StreamController<List<MessageModel>> messageStreamController = StreamController();

  void dispose() {
    messageStreamController.close();
    scrollController.dispose();
  }

  void widgetReady() {
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }

    if (initialMessageList.isNotEmpty) {
      scrollToLastMessage();
    }
  }

  @override
  void addMessage(MessageModel messageModel) {
    if (messageStreamController.isClosed) return;
    inflateMessage(messageModel);
    initialMessageList.insert(0, messageModel);
    messageStreamController.sink.add(initialMessageList);
    scrollToLastMessage();
  }

  @override
  void loadMoreData(List<MessageModel> messageList) {}

  void scrollToLastMessage() {
    // TODO
  }

  /// 设置消息时间是否可以暂时
  void inflateMessage(MessageModel message) {
    int pellet = (message.createdAt / (timePellet * 1000)).truncate();
    if(!pelletShow.contains(pellet)){
      pelletShow.add(pellet);
      message.showCreatedTime = true;
    } else {
      message.showCreatedTime = false;
    }
  }
}

abstract class IChatController {
  void addMessage(MessageModel messageModel);

  void loadMoreData(List<MessageModel> messageList);
}
