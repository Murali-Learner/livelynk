import 'package:hive/hive.dart';
import 'package:livelynk/models/room_model.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final List<User> contacts;
  @HiveField(4)
  final List<Room> rooms;
  @HiveField(5)
  final String? roomId;
  @HiveField(6)
  final String? contactId;

  User({
    required this.username,
    this.userId,
    this.roomId,
    this.contactId,
    this.email,
    this.contacts = const [],
    this.rooms = const [],
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'].toString(),
      roomId: json['roomId'].toString(),
      contactId: json['contactId'].toString(),
      username: json['userName'] ?? json['username'] ?? '',
      email: json['email'].toString(),
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map((contact) => User.fromJson(contact))
              .toList() ??
          [],
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((room) => Room.fromJson(room))
              .toList() ??
          [],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'contactId': contactId,
      'roomId': roomId,
      'email': email,
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }

  // Copy with method
  User copyWith({
    String? userId,
    String? username,
    String? email,
    String? roomId,
    String? contactId,
    List<User>? contacts,
    List<Room>? rooms,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      roomId: roomId ?? this.roomId,
      contactId: contactId ?? this.contactId,
      contacts: contacts ?? this.contacts,
      rooms: rooms ?? this.rooms,
    );
  }
}
