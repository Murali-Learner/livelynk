import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livelynk/providers/home_chat_provider.dart';
import 'package:livelynk/providers/home_provider.dart';
import 'package:livelynk/providers/user_chat_provider.dart';
import 'package:livelynk/views/calls/calls_page.dart';
import 'package:livelynk/views/chats/chat_home/chat_home_page.dart';
import 'package:livelynk/views/contacts/contacts_page.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/views/auth/login_view.dart';
import 'package:livelynk/utils/extensions/context_extensions.dart';
import 'package:livelynk/utils/extensions/naming_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late HomeChatProvider _homeChatProvider;
  late UserChatProvider userChatProvider;

  @override
  void initState() {
    _homeChatProvider = context.read<HomeChatProvider>();
    userChatProvider = Provider.of<UserChatProvider>(context, listen: false);

    _homeChatProvider.connectSocket(
      context: context,
      userChatProvider: userChatProvider,
    );
    _homeChatProvider.fetchChatUsers();
    log("user id ${HiveService.currentUser!.userId}");
    super.initState();
  }

  final List<Widget> _screens = [
    const ChatHomePage(),
    const ContactsPage(),
    const CallsPage()
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        automaticallyImplyLeading: false,
        title: Text('Hey ${HiveService.currentUser!.username.toPascalCase()}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              context.pushRemoveUntil(to: LoginPage());
            },
          ),
        ],
      ),
      body: Consumer<HomeProvider>(builder: (context, provider, _) {
        return _screens[provider.selectedIndex];
      }),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        selectedItemColor: Colors.green,
        // unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
        ],
        currentIndex: homeProvider.selectedIndex,
        onTap: (value) {
          if (value == 0) {
            _homeChatProvider.fetchChatUsers();
          }
          homeProvider.onItemTapped(value);
        },
      ),
    );
  }
}
