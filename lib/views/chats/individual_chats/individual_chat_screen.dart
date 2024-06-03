import 'package:flutter/material.dart';
import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/providers/home_chat_provider.dart';
import 'package:livelynk/providers/user_chat_provider.dart';
import 'package:livelynk/views/chats/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late HomeChatProvider homeChatProvider;
  late UserChatProvider userChatProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeChatProvider = Provider.of<HomeChatProvider>(context, listen: false);
    userChatProvider = Provider.of<UserChatProvider>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await homeChatProvider.init(context: context);
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    // homeChatProvider.removeSendMessageSocketListener(
    //   openedChatUserId: userChatProvider.contact!.userId!,
    // );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room: ${userChatProvider.contact!.username}'),
      ),
      body: Consumer2<HomeChatProvider, UserChatProvider>(builder: (
        context,
        homeChatProvider,
        userChatProvider,
        _,
      ) {
        if ((userChatProvider.contact?.chatMessages ?? []).isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }

        return Column(
          children: [
            Expanded(
              child: (userChatProvider.contact!.chatMessages ?? []).isEmpty
                  ? const Center(
                      child: Text('No messages yet'),
                    )
                  : ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8.0),
                      itemCount:
                          (userChatProvider.contact!.chatMessages ?? []).length,
                      itemBuilder: (context, index) {
                        final message =
                            (userChatProvider.contact!.chatMessages ??
                                [])[index];
                        return ChatBubble(
                          message: message,
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      homeChatProvider.sendMessage(
                        message: _controller.text.trim(),
                        toContact: userChatProvider.contact!,
                      );
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
