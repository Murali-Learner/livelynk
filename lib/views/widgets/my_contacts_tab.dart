import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/views/widgets/user_tile.dart';

class MyContactsTab extends StatefulWidget {
  const MyContactsTab({super.key});

  @override
  MyContactsTabState createState() => MyContactsTabState();
}

class MyContactsTabState extends State<MyContactsTab> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).whenComplete(
        () => Provider.of<AuthProvider>(context, listen: false).fetchMyUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return provider.myUsers.isEmpty
          ? const Center(
              child: Text("No Contacts"),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: provider.myUsers.length,
              itemBuilder: (context, index) {
                final user = provider.myUsers[index];

                return UserTile(
                  contact: user,
                  isMyuser: true,
                );
              },
            );
    });
  }
}
