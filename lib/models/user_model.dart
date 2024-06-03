import 'package:hive/hive.dart';
import 'package:livelynk/models/chat_message.dart';
import 'package:livelynk/models/contact_model.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final int? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? roomId;
  @HiveField(4)
  final Map<int, Contact>? unRequestedUsers;
  @HiveField(5)
  final Map<int, Contact>? requestedUsers;
  @HiveField(6)
  final Map<int, Contact>? invitedUsers;
  @HiveField(7)
  final Map<int, Contact>? acceptedUsers;
  @HiveField(8)
  final Map<int, Contact>? originalUsers;

  User({
    required this.username,
    this.userId,
    this.roomId,
    this.email,
    this.unRequestedUsers,
    this.requestedUsers,
    this.invitedUsers,
    this.acceptedUsers,
    this.originalUsers,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      roomId: json['roomId'].toString(),
      username: json['userName'] ?? json['username'] ?? '',
      email: json['email'].toString(),
    );
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
  User copyWith({
    int? userId,
    String? username,
    String? email,
    String? roomId,
    String? contactId,
    Map<int, User>? contacts,
    List<ChatMessage>? chatMessages,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      roomId: roomId ?? this.roomId,
    );
  }
}
