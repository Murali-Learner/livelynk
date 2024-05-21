import 'package:flutter/material.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/views/incoming_call_page.dart';
import 'package:livelynk/views/utils/extensions/context_extensions.dart';
import 'package:livelynk/views/utils/extensions/naming_extension.dart';
import 'package:livelynk/views/utils/extensions/spacer_extension.dart';
import 'package:livelynk/views/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.contact});
  final User contact;
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(
                  navigateTo:
                      IncomingCallPage(callerName: widget.contact.username));
            },
            icon: const Icon(Icons.add_ic_call_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call_outlined),
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                widget.contact.username[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            10.hSpace,
            Text(
              widget.contact.username.toPascalCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Consumer<AuthProvider>(
                builder: (context, state, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return
                      //  widget..messages.isEmpty
                      //     ? const Center(
                      //         child: Text("Messages Are Empty"),
                      //       )
                      //     :
                      ListView.builder(
                    controller: _scrollController,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ChatBubble(
                        message: "message",
                        isMe: index == 1 ? true : false,
                      );
                    },
                  );
                },
              ),
            ),
            20.vSpace,
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (value) {
                      sendMessage();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter a message',
                    ),
                  ),
                ),
                20.hSpace,
                ElevatedButton(
                  onPressed: () {
                    sendMessage();
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {}
}
