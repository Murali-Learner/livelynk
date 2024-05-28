import 'package:flutter/material.dart';
import 'package:livelynk/providers/contact_provider.dart';
import 'package:livelynk/providers/home_chat_provider.dart';
import 'package:livelynk/services/home_socket.dart';
import 'package:livelynk/views/chats/widgets/chat_contact_tile.dart';
import 'package:provider/provider.dart';

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
    await Future.delayed(Duration.zero).whenComplete(
      () =>
          Provider.of<ContactProvider>(context, listen: false).fetchChatUsers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(builder: (context, provider, _) {
      return Column(
        children: [
          Expanded(
            child: provider.chatUsers.isEmpty
                ? Center(
                    child: Text(
                      "No contacts found",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.chatUsers.length,
                    itemBuilder: (context, index) {
                      return ChatContactTile(user: provider.chatUsers[index]);
                    },
                  ),
          )
        ],
      );
    });
  }
}
