import 'package:flutter/material.dart';
import 'package:livelynk/models/chat_message.dart';
import 'package:livelynk/models/contact_model.dart';

class UserChatProvider extends ChangeNotifier {
  Contact? contact;

  set setContact(Contact contact) {
    this.contact = contact;
    notifyListeners();
  }

  void setMessages(List<ChatMessage> messages) {
    contact = contact?.copyWith(chatMessages: messages);
    notifyListeners();
  }

  void clearMessages() {
    contact = null;
    notifyListeners();
  }
}
