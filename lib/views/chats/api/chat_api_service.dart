import 'dart:convert';

import 'package:livelynk/models/chat_message.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/services/http_service.dart';
import 'package:livelynk/services/api_routes.dart';

class ChatApiService {
  static Future<List<ChatMessage>> getChatHistory(
    int senderId,
  ) async {
    final receiverId = HiveService.currentUser?.userId;
    try {
      final response = await HttpService.send(
        'GET',
        "${APIRoutes.getChatHistory}senderId=$senderId&receiverId=$receiverId",
      );
      if (response.lastOrNull == 200) {
        final Map<String, dynamic> responseData = json.decode(response.first);
        if (responseData['data'] == null) {
          return [];
        }
        final List<dynamic> chatHistory = responseData['data'];
        final List<ChatMessage> chatMessages =
            chatHistory.map((chat) => ChatMessage.fromJson(chat)).toList();
        return chatMessages;
      } else {
        return [];
      }
    } catch (e) {
      print("Error occurred while fetching chat history: $e ");
      return [];
    }
  }
}
