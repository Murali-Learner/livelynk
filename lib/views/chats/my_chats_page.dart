import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/providers/auth_provider.dart';

class MyChatsPage extends StatefulWidget {
  const MyChatsPage({super.key});

  @override
  MyChatsPageState createState() => MyChatsPageState();
}

class MyChatsPageState extends State<MyChatsPage> {
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
