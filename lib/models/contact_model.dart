import 'package:hive/hive.dart';
import 'package:livelynk/models/chat_message.dart';
part 'contact_model.g.dart';

@HiveType(typeId: 1)
class Contact {
  @HiveField(0)
  final int? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? roomId;
  @HiveField(4)
  final List<ChatMessage>? chatMessages;
  @HiveField(5)
  final String? contactId;

  Contact({
    required this.username,
    this.userId,
    this.roomId,
    this.email,
    this.chatMessages,
    this.contactId,
  });

  // From JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      userId: json['userId'],
      roomId: json['roomId'].toString(),
      username: json['userName'] ?? json['username'] ?? '',
      email: json['email'].toString(),
      chatMessages: _getChatMessages(json['chatMessages']),
      contactId: json['contactId'],
    );
  }

  static List<ChatMessage>? _getChatMessages(List<dynamic>? messages) {
    if (messages != null) {
      return messages.map((message) => ChatMessage.fromJson(message)).toList();
    }
    return null;
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'roomId': roomId,
      'email': email,
    };
  }

  // Copy with method
  Contact copyWith({
    int? userId,
    String? username,
    String? email,
    String? roomId,
    String? contactId,
    Map<int, Contact>? contacts,
    List<ChatMessage>? chatMessages,
  }) {
    return Contact(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      roomId: roomId ?? this.roomId,
      chatMessages: chatMessages ?? this.chatMessages,
      contactId: contactId ?? this.contactId,
    );
  }
}
