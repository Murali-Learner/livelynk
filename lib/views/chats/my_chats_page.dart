import 'package:flutter/material.dart';
import 'package:livelynk/providers/contact_provider.dart';
import 'package:provider/provider.dart';

class MyChatsPage extends StatefulWidget {
  const MyChatsPage({super.key});

  @override
  MyChatsPageState createState() => MyChatsPageState();
}

class MyChatsPageState extends State<MyChatsPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration.zero).whenComplete(() =>
        Provider.of<ContactProvider>(context, listen: false).fetchChatUsers());
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Expanded(child: ListView.builder(
        //   itemBuilder: (context, index) {
        //     return const ListTile();
        //   },
        // ))
      ],
    );
  }
}
