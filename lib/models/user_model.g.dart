// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      username: fields[1] as String,
      userId: fields[0] as int?,
      roomId: fields[3] as String?,
      email: fields[2] as String?,
      unRequestedUsers: (fields[4] as Map?)?.cast<int, Contact>(),
      requestedUsers: (fields[5] as Map?)?.cast<int, Contact>(),
      invitedUsers: (fields[6] as Map?)?.cast<int, Contact>(),
      acceptedUsers: (fields[7] as Map?)?.cast<int, Contact>(),
      originalUsers: (fields[8] as Map?)?.cast<int, Contact>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.roomId)
      ..writeByte(4)
      ..write(obj.unRequestedUsers)
      ..writeByte(5)
      ..write(obj.requestedUsers)
      ..writeByte(6)
      ..write(obj.invitedUsers)
      ..writeByte(7)
      ..write(obj.acceptedUsers)
      ..writeByte(8)
      ..write(obj.originalUsers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
