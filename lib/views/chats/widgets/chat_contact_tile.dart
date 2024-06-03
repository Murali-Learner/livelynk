import 'package:flutter/material.dart';
import 'package:livelynk/models/chat_message.dart';
import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/providers/user_chat_provider.dart';
import 'package:livelynk/utils/extensions/context_extensions.dart';
import 'package:livelynk/views/chats/individual_chats/individual_chat_screen.dart';
import 'package:provider/provider.dart';

class ChatContactTile extends StatelessWidget {
  const ChatContactTile({
    super.key,
    required this.user,
  });

  final Contact user;

  @override
  Widget build(BuildContext context) {
    ChatMessage? lastMessage =
        (user.chatMessages ?? []).isNotEmpty ? user.chatMessages?.first : null;

    return ListTile(
      onTap: () {
        context.read<UserChatProvider>().setContact = user;
        context.push(navigateTo: const ChatScreen());
      },
      tileColor: context.theme.cardColor,
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: Text(
          user.username[0].toUpperCase(),
          style: context.textTheme.titleMedium,
        ),
      ),
      title: Text(
        user.username,
        style: context.textTheme.titleMedium,
      ),
      subtitle: Text(
        (lastMessage?.message) ?? '',
        style: context.textTheme.labelMedium,
      ),
    );
  }
}
