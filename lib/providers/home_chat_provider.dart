import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:livelynk/models/chat_message.dart';
import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/providers/user_chat_provider.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/services/home_socket.dart';
import 'package:livelynk/utils/toast.dart';
import 'package:livelynk/views/chats/api/chat_api_service.dart';
import 'package:livelynk/views/contacts/api/contact_api_service.dart';
import 'package:provider/provider.dart';

class HomeChatProvider extends ChangeNotifier {
  List<ChatMessage> incomingChatMessages = const [];
  Map<int, Contact> _chatUsers = {};
  Map<int, Contact> get chatUsers => _chatUsers;
  User get currentUser {
    return HiveService.currentUser!;
  }

  Future<void> fetchChatUsers() async {
    try {
      _chatUsers = await ContactApiService.fetchChatContacts(
        currentUser.userId,
      );
      notifyListeners();
    } catch (e) {
      showErrorToast(message: e.toString());
    }
  }

  connectSocket(
      {required BuildContext context,
      required UserChatProvider userChatProvider}) {
    HomeSocket.instance.init();
    HomeSocket.instance.onOpen = () {
      print("Home socket connected");
    };
    HomeSocket.instance.onClose = () {
      print("HOme socket closed");
    };
    HomeSocket.instance.onJoinedRoom = (dynamic joinedUserId) {
      print("User Joined $joinedUserId");
    };

    HomeSocket.instance.connect();

    HomeSocket.instance.socket!.emitWithAck("joinRoom",
        {"roomId": currentUser.roomId, "userId": currentUser.userId});
    log("message-${currentUser.userId}");
    HomeSocket.instance.socket?.on("message-${currentUser.userId}", (message) {
      log("Here received $message");
      if (message == null) {
        return;
      }
      ChatMessage chatMessage = ChatMessage.fromJson(message);

      onMessage(
        chatMessage: chatMessage,
        userChatProvider: userChatProvider,
        isSending: chatMessage.from == currentUser.userId,
      );
    });
  }

  void addSendMessageSocketListener({
    required UserChatProvider userChatProvider,
  }) {
    // log("sentACK-${userChatProvider.contact!.userId}");
    // HomeSocket.instance.socket
    //     ?.on("sentACK-${userChatProvider.contact!.userId}", (message) {
    //   log("Here sent $message");
    //   onMessage(
    //     data: message,
    //     userChatProvider: userChatProvider,
    //     isSending: true,
    //   );
    // });
  }

  void removeSendMessageSocketListener({
    required int openedChatUserId,
  }) {
    // HomeSocket.instance.socket?.off("sentACK-$openedChatUserId");
  }

  void onMessage({
    required ChatMessage chatMessage,
    required UserChatProvider userChatProvider,
    bool isSending = false,
  }) {
    try {
      log("I came here");
      int consideredContactId = isSending ? chatMessage.to : chatMessage.from;
      if (_chatUsers.containsKey(consideredContactId)) {
        final int? openedChatUserId = userChatProvider.contact?.userId;

        Contact chatUser = _chatUsers[consideredContactId]!;
        chatUser.chatMessages?.insert(0, chatMessage);
        _chatUsers[consideredContactId] = chatUser.copyWith(
          chatMessages: chatUser.chatMessages,
        );
        if ((openedChatUserId == chatMessage.from) ||
            (openedChatUserId == chatMessage.to)) {
          userChatProvider.setMessages(chatUser.chatMessages ?? []);
          log((userChatProvider.contact?.chatMessages?.length).toString());
        }
        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }

  void sendMessage({
    required Contact toContact,
    String message = "",
  }) {
    HomeSocket.instance.socket?.emit("sendMessage", {
      "roomId": toContact.roomId,
      "toUserId": toContact.userId,
      "fromUserId": currentUser.userId,
      "message": message
    });
  }

  Future<void> getChatHistory({
    required UserChatProvider userChatProvider,
  }) async {
    List<ChatMessage> messages =
        await ChatApiService.getChatHistory(userChatProvider.contact!.userId!);
    if (_chatUsers.containsKey(userChatProvider.contact!.userId)) {
      Contact chatUser = _chatUsers[userChatProvider.contact!.userId]!.copyWith(
        chatMessages: messages,
      );
      _chatUsers[userChatProvider.contact!.userId!] = chatUser;
      userChatProvider.setMessages(chatUser.chatMessages ?? []);

      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> init({
    required BuildContext context,
  }) async {
    UserChatProvider userChatProvider =
        Provider.of<UserChatProvider>(context, listen: false);
    HomeSocket.instance.socket?.emitWithAck("joinRoom", {
      "roomId": userChatProvider.contact?.roomId,
      "userId": userChatProvider.contact?.userId,
    });
    await getChatHistory(userChatProvider: userChatProvider);
    addSendMessageSocketListener(userChatProvider: userChatProvider);
  }
}
