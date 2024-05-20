import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_chat_clone/models/user_model.dart';
import 'package:whatsapp_chat_clone/providers/auth_provider.dart';
import 'package:whatsapp_chat_clone/views/utils/extensions/context_extensions.dart';
import 'package:whatsapp_chat_clone/views/utils/extensions/naming_extension.dart';
import 'package:whatsapp_chat_clone/views/utils/extensions/spacer_extension.dart';

class ChatScreen extends StatefulWidget {
  final User contact;

  const ChatScreen({super.key, required this.contact});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  // final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                widget.contact.username[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            10.hSpace,
            Text(
              widget.contact.username.toPascalCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Consumer<AuthProvider>(builder: (context, provider, _) {
        return const Column(
          children: [],
        );
      }),
    );
  }
}
