import 'package:flutter/material.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/services/home_socket.dart';
import 'package:livelynk/utils/toast.dart';

class HomeChatProvider extends ChangeNotifier {
  connectSocket() {
    HomeSocket.instance.init();
    HomeSocket.instance.onOpen = () {
      print("HOme socket connected");
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
    HomeSocket.instance.socket!.emitWithAck("sendMessage", {
      "roomId": HiveService.currentUser?.roomId,
      "senderEmail": HiveService.currentUser?.userId,
      "message": "Hello i came here"
    });
  }
}
