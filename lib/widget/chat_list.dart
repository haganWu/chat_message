import 'package:chat_message/core/chat_controller.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  final ChatController chatController;
  final EdgeInsetsGeometry? padding;

  const ChatList({Key? key, required this.chatController, this.padding}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ChatController get chatController => widget.chatController;

  ScrollController get scrollController => chatController.scrollController;

  Widget get _chatStreamBuilder => StreamBuilder<List<MessageModel>>(
      stream: chatController.messageStreamController.stream,
      builder: (BuildContext context, AsyncSnapshot<List<MessageModel>> snapshot) {
        return snapshot.connectionState == ConnectionState.active
            ? ListView.builder(
                shrinkWrap: true,
                reverse: true,
                padding: widget.padding,
                controller: scrollController,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var model = snapshot.data![index];
                  // TODO
                  return _buildMessageWidget(key: model.key, message: model);
                })
            : const Center(
                child: CircularProgressIndicator(),
              );
      });

  @override
  void initState() {
    super.initState();
    chatController.widgetReady();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 配合ListView的shrinkWrap: true使用，解决数据较少时数据底部对齐的问题
    return Align(
      alignment: Alignment.topCenter,
      child: _chatStreamBuilder,
    );
  }

  Widget _buildMessageWidget({required GlobalKey<State<StatefulWidget>> key, required MessageModel message}) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(color: message.ownerType == OwnerType.receiver ? Colors.amberAccent : Colors.deepOrangeAccent),
      child: Text('${message.ownerName} - ${message.content} -${message.avatar}', style: TextStyle(fontSize: 12, color: message.ownerType == OwnerType.receiver ? Colors.green : Colors.blueGrey)),
    );
  }
}
