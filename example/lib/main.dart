import 'package:chat_message/core/chat_controller.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/widget/chat_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatMessageExample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ChatMessageExample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;
  final List<MessageModel> _messageList = [
    MessageModel(ownerType: OwnerType.receiver, content: 'ChatGPT是由OpenAI研发的聊天机器人程序', createdAt: DateTime.parse('2023-06-20 08:08:08').millisecondsSinceEpoch, id: 2, avatar: 'https://o.devio.org/images/o_as/avatar/tx4.jpeg', ownerName: 'ChatGPT'),
    MessageModel(ownerType: OwnerType.sender, content: '介绍一下ChatGPT', createdAt: DateTime.parse('2023-06-20 18:18:18').millisecondsSinceEpoch, id: 1, avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg', ownerName: 'Imooc'),
  ];

  late ChatController chatController;

  @override
  void initState() {
    super.initState();
    chatController = ChatController(initialMessageList: _messageList, scrollController: ScrollController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(child: ChatList(chatController: chatController)),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround ,
            children: [ElevatedButton(onPressed: _send, child: const Text('Send'))],
          ),
          const SizedBox(height: 12,)
        ],
      ),
    );
  }

  void _send() {
    count++;
    chatController.addMessage(MessageModel(ownerType: OwnerType.sender, content: 'Hello-$count', createdAt: DateTime.now().millisecondsSinceEpoch, id: count+2, avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg', ownerName: 'Imooc'));
    Future.delayed(const Duration(milliseconds: 2000),(){chatController.addMessage(
      MessageModel(ownerType: OwnerType.receiver, content: 'ChatGPT Response - $count', createdAt: DateTime.now().millisecondsSinceEpoch, id: count+3, avatar: 'https://o.devio.org/images/o_as/avatar/tx4.jpeg', ownerName: 'ChatGPT'),
    );});
  }
}
