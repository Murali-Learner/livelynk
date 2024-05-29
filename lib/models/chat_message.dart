import 'package:hive/hive.dart';
import 'package:livelynk/services/hive_service.dart';
part 'chat_message.g.dart';

@HiveType(typeId: 2)
class ChatMessage {
  @HiveField(0)
  final String messageId;
  @HiveField(1)
  final DateTime timeSent;
  @HiveField(2)
  final int from;
  @HiveField(3)
  final int to;
  @HiveField(4)
  final String message;

  bool get isMe => from == HiveService.currentUser?.userId;

  ChatMessage({
    required this.messageId,
    required this.timeSent,
    required this.from,
    required this.to,
    required this.message,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['chatId'],
      timeSent: DateTime.parse(json['timestamp']),
      from: json['senderId'],
      to: json['receiverId'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'timeSent': timeSent.toIso8601String(),
      'from': from,
      'to': to,
      'message': message,
    };
  }
}
