import 'dart:async';

import 'package:chat_message/models/message_model.dart';
import 'package:flutter/widgets.dart';
import '../widget/default_message_widget.dart';

class ChatController implements IChatController {
  // 初始化数据
  final List<MessageModel> initialMessageList;
  final ScrollController scrollController;

  /// Provider MessageWidgetBuilder to customize your bubble style
  final MessageWidgetBuilder? messageWidgetBuilder;

  // 展示时间间隔,单位:秒
  final int timePellet;
  List<int> pelletShow = [];

  ChatController({
    required this.initialMessageList,
    required this.scrollController,
    required this.timePellet,
    this.messageWidgetBuilder,
  }) {
    for (var message in initialMessageList.reversed) {
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
  void deleteMessage(MessageModel messageModel) {
    if (messageStreamController.isClosed) return;
    initialMessageList.remove(messageModel);
    // 重新计算日期
    pelletShow.clear();
    for(var message in initialMessageList.reversed){
      inflateMessage(message);
    }
    messageStreamController.sink.add(initialMessageList);
  }

  @override
  void loadMoreData(List<MessageModel> messageList) {
    // List反转后是从底部向上展示，因此消息顺序也需要进行反转
    messageList = List.from(messageList.reversed);
    List<MessageModel> tempList = [...initialMessageList, ...messageList];
    pelletShow.clear();
    for (var message in tempList.reversed) {
      inflateMessage(message);
    }
    initialMessageList.clear();
    initialMessageList.addAll(tempList);
    if (messageStreamController.isClosed) return;
    messageStreamController.sink.add(initialMessageList);
  }

  ///  消息滚动到底部
  void scrollToLastMessage() {
    // fix ScrollController not attached to any scroll views
    if (!scrollController.hasClients) {
      return;
    }
    scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  /// 设置消息时间是否可以暂时
  void inflateMessage(MessageModel message) {
    int pellet = (message.createdAt / (timePellet * 1000)).truncate();
    if (!pelletShow.contains(pellet)) {
      pelletShow.add(pellet);
      message.showCreatedTime = true;
    } else {
      message.showCreatedTime = false;
    }
  }

}

abstract class IChatController {
  void addMessage(MessageModel messageModel);

  void deleteMessage(MessageModel messageModel);

  void loadMoreData(List<MessageModel> messageList);
}
