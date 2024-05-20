import 'package:flutter/material.dart';
import 'package:whatsapp_chat_clone/services/hive_service.dart';
import 'package:whatsapp_chat_clone/views/home_page.dart';
import 'package:whatsapp_chat_clone/views/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    if (HiveService.currentUser != null) {
      return const HomePage();
    } else {
      return LoginPage();
    }
  }
}
