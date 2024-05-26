import 'package:flutter/material.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/providers/contact_provider.dart';
import 'package:provider/provider.dart';

class ChatContactTile extends StatelessWidget {
  const ChatContactTile({
    super.key,
    required this.user,
  });

  final Contact user;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContactProvider>(context);
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.username[0].toUpperCase()),
      ),
      title: Text(user.username),
      subtitle: Text(user.email!),
    );
  }
}
