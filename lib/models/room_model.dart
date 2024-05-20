import 'package:hive/hive.dart';
import 'package:whatsapp_chat_clone/models/chat_messsage.dart';
part 'room_model.g.dart';

@HiveType(typeId: 2)
class Room {
  @HiveField(0)
  final String? roomId;
  @HiveField(1)
  final List<String> users;
  @HiveField(2)
  final List<ChatMessage> messages;

  Room({
    this.roomId,
    this.users = const [],
    this.messages = const [],
  });

  // From JSON
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      users: (json['users'] as List<dynamic>?)
              ?.map((user) => user as String)
              .toList() ??
          [],
      messages: (json['messages'] as List<dynamic>?)
              ?.map((message) => ChatMessage.fromJson(message))
              .toList() ??
          [],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'users': users,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  // Copy with method
  Room copyWith({
    String? roomId,
    List<String>? users,
    List<ChatMessage>? messages,
  }) {
    return Room(
      roomId: roomId ?? this.roomId,
      users: users ?? this.users,
      messages: messages ?? this.messages,
    );
  }
}
