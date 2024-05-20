import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_chat_clone/providers/auth_provider.dart';
import 'package:whatsapp_chat_clone/services/hive_service.dart';
import 'package:whatsapp_chat_clone/views/login_view.dart';
import 'package:whatsapp_chat_clone/views/utils/extensions/context_extensions.dart';
import 'package:whatsapp_chat_clone/views/utils/extensions/naming_extension.dart';
import 'package:whatsapp_chat_clone/views/widgets/my_chats_tab.dart';
import 'package:whatsapp_chat_clone/views/widgets/my_contacts_tab.dart';
import 'package:whatsapp_chat_clone/views/widgets/total_contacts_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Hey ${HiveService.currentUser!.username.toPascalCase()}!'),
        bottom: TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'My Contacts'),
            Tab(text: 'Total Contacts'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              log(" HiveService  ${HiveService.currentUser!.toJson()}");
              authProvider.logout();
              context.pushRemoveUntil(to: LoginPage());
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(builder: (context, provider, _) {
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? Center(child: Text(provider.errorMessage!))
                : TabBarView(
                    controller: _controller,
                    children: const [
                      MyChatsTab(),
                      MyContactsTab(),
                      TotalContactsTab(),
                    ],
                  );
      }),
    );
  }
}
