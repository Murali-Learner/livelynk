import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_chat_clone/providers/auth_provider.dart';

class MyChatsTab extends StatefulWidget {
  const MyChatsTab({super.key});

  @override
  MyChatsTabState createState() => MyChatsTabState();
}

class MyChatsTabState extends State<MyChatsTab> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration.zero).whenComplete(() =>
        Provider.of<AuthProvider>(context, listen: false).fetchChatUsers());
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Impliment chats Tab"),
    );
  }
}
