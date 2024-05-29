import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:livelynk/models/chat_message.dart';
import 'package:livelynk/models/contact_model.dart';
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

  Future<void> fetchChatUsers() async {
    try {
      _chatUsers.clear();
      _chatUsers = await ContactApiService.fetchChatContacts(
        HiveService.currentUser!.userId!,
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
    HomeSocket.instance.onReceivedMessage = (dynamic receivedMessage) {
      showSuccessToast(message: receivedMessage["message"].toString());
    };
    HomeSocket.instance.connect();

    HomeSocket.instance.socket!.emitWithAck("joinRoom", {
      "roomId": HiveService.currentUser?.roomId,
      "userId": HiveService.currentUser?.userId
    });
    final int currentUserId = HiveService.currentUser?.userId ?? 0;
    HomeSocket.instance.socket?.on("received-$currentUserId", (data) {
      onMessageReceived(data: data, userChatProvider: userChatProvider);
    });
    HomeSocket.instance.socket?.on("sentACK-$currentUserId", (messageId) {
      log("Sent ACK $messageId");
    });
  }

  void onMessageReceived({
    required dynamic data,
    required UserChatProvider userChatProvider,
  }) {
    if (data != null) {
      ChatMessage chatMessage = ChatMessage.fromJson(data);
      if (_chatUsers.containsKey(chatMessage.from)) {
        final int? openedChatUserId = userChatProvider.contact?.userId;
        Contact chatUser = _chatUsers[chatMessage.from]!;
        chatUser.chatMessages?.add(chatMessage);
        _chatUsers[chatMessage.from] = chatUser.copyWith(
          chatMessages: chatUser.chatMessages,
        );
        if ((openedChatUserId == chatMessage.from) ||
            (openedChatUserId == chatMessage.to)) {
          userChatProvider.setMessages(chatUser.chatMessages ?? []);
          log((userChatProvider.contact?.chatMessages?.length).toString());
        }
        notifyListeners();
      }
    }
  }

  void sendMessage({
    required Contact toContact,
    String message = "",
  }) {
    HomeSocket.instance.socket?.emit("sendMessage", {
      "roomId": toContact.roomId,
      "toUserId": toContact.userId,
      "fromUserId": HiveService.currentUser?.userId ?? "",
      "message": message
    });
  }

  Future<void> getChatHistory({
    required Contact user,
    required UserChatProvider userChatProvider,
  }) async {
    List<ChatMessage> messages =
        await ChatApiService.getChatHistory(user.userId!);
    if (_chatUsers.containsKey(user.userId)) {
      Contact chatUser = _chatUsers[user.userId]!.copyWith(
        chatMessages: messages,
      );
      _chatUsers[user.userId!] = chatUser;
      userChatProvider.setMessages(chatUser.chatMessages ?? []);

      notifyListeners();
    }
    notifyListeners();
  }

  void joinRoom(Contact contact) {
    HomeSocket.instance.socket?.emitWithAck("joinRoom", {
      "roomId": contact.roomId,
      "userId": contact.userId,
    });
  }
}
