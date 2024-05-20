import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_chat_clone/providers/auth_provider.dart';
import 'package:whatsapp_chat_clone/views/widgets/user_tile.dart';

class TotalContactsTab extends StatefulWidget {
  const TotalContactsTab({super.key});

  @override
  TotalContactsTabState createState() => TotalContactsTabState();
}

class TotalContactsTabState extends State<TotalContactsTab> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).whenComplete(() =>
        Provider.of<AuthProvider>(context, listen: false).fetchAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return provider.allUsers.isEmpty
          ? const Center(
              child: Text("No Contacts"),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: provider.allUsers.length,
              itemBuilder: (context, index) {
                final user = provider.allUsers[index];

                return UserTile(
                  contact: user,
                );
              },
            );
    });
  }
}
