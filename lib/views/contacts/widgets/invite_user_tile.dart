import 'package:flutter/material.dart';
import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/providers/contact_provider.dart';
import 'package:provider/provider.dart';

class InviteUserTile extends StatelessWidget {
  const InviteUserTile({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContactProvider>(context);
    return ListTile(
      leading: CircleAvatar(
        child: Text(contact.username[0].toUpperCase()),
      ),
      title: Text(contact.username),
      subtitle: Text(contact.email!),
      trailing: TextButton(
        onPressed: () async {
          await provider.addContact(contact.userId!);
        },
        child: const Text('Invite'),
      ),
    );
  }
}
