import 'package:flutter/material.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/views/home_page.dart';
import 'package:livelynk/views/login_view.dart';

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
