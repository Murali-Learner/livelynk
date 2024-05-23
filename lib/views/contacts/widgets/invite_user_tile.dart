import 'package:flutter/material.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class InviteUserTile extends StatelessWidget {
  const InviteUserTile({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.username[0].toUpperCase()),
      ),
      title: Text(user.username),
      subtitle: Text(user.email!),
      trailing: ElevatedButton(
        onPressed: () async {
          await provider.addContact(user.email!);
        },
        child: const Text('Invite'),
      ),
    );
  }
}
