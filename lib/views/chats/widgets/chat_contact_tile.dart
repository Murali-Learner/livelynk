import 'package:flutter/material.dart';
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
    return ListTile(
      onTap: () {
        context.read<UserChatProvider>().setContact = user;
        context.push(navigateTo: const ChatScreen());
      },
      tileColor: context.theme.cardColor,
      leading: CircleAvatar(
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
        user.email!,
        style: context.textTheme.labelMedium,
      ),
    );
  }
}
