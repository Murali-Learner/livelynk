import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/views/chat_page.dart';
import 'package:livelynk/views/utils/extensions/context_extensions.dart';
import 'package:livelynk/views/utils/extensions/naming_extension.dart';

class UserTile extends StatelessWidget {
  final User contact;
  final bool isMyuser;

  const UserTile({super.key, required this.contact, this.isMyuser = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        onTap: () {
          if (isMyuser) context.push(navigateTo: ChatPage(contact: contact));
        },
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            contact.username[0].toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          contact.username.toPascalCase(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(contact.email!),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isMyuser)
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .deleteContact(contact.userId!);
                },
              ),
            if (!isMyuser)
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add_call),
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .addContact(contact.userId!);
                },
              ),
          ],
        ),
      ),
    );
  }
}
