import 'package:hive/hive.dart';
part 'chat_messsage.g.dart';

@HiveType(typeId: 1)
class ChatMessage {
  @HiveField(0)
  final String messageId;
  @HiveField(1)
  final DateTime timeSent;
  @HiveField(2)
  final String from;
  @HiveField(3)
  final String to;
  @HiveField(4)
  final String message;

  ChatMessage({
    required this.messageId,
    required this.timeSent,
    required this.from,
    required this.to,
    required this.message,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['messageId'],
      timeSent: DateTime.parse(json['timeSent']),
      from: json['from'],
      to: json['to'],
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
