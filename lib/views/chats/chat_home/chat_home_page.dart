import 'package:flutter/material.dart';
import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/providers/home_chat_provider.dart';
import 'package:livelynk/views/chats/widgets/chat_contact_tile.dart';
import 'package:provider/provider.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  ChatHomePageState createState() => ChatHomePageState();
}

class ChatHomePageState extends State<ChatHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChatProvider>(builder: (context, provider, _) {
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
                      final int key = provider.chatUsers.keys.elementAt(index);
                      final Contact contact = provider.chatUsers[key]!;
                      return ChatContactTile(user: contact);
                    },
                  ),
          )
        ],
      );
    });
  }
}
