import 'dart:async';

import 'package:chat_message/models/message_model.dart';
import 'package:flutter/widgets.dart';

class ChatController implements IChatController {
  // 初始化数据
  final List<MessageModel> initialMessageList;
  final ScrollController scrollController;

  ChatController({required this.initialMessageList, required this.scrollController});

  StreamController<List<MessageModel>> messageStreamController = StreamController();

  void dispose(){
    messageStreamController.close();
    scrollController.dispose();
  }

  void widgetReady(){
    if(!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }

    if(initialMessageList.isNotEmpty) {
      scrollToLastMessage();
    }
  }

  @override
  void addMessage(MessageModel messageModel) {
    if(messageStreamController.isClosed) return;
    initialMessageList.insert(0, messageModel);
    messageStreamController.sink.add(initialMessageList);
    scrollToLastMessage();
  }

  @override
  void loadMoreData(List<MessageModel> messageList) {}

  void scrollToLastMessage() {
    // TODO
  }
}

abstract class IChatController {
  void addMessage(MessageModel messageModel);

  void loadMoreData(List<MessageModel> messageList);
}
