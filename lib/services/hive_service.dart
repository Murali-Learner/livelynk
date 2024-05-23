import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:livelynk/models/chat_messsage.dart';
import 'package:livelynk/models/room_model.dart';
import 'package:livelynk/models/user_model.dart';

class HiveService {
  static final HiveService _hiveService = HiveService._internal();
  static const String _boxName = 'userBox';
  static Box<dynamic>? _box;
  static User? currentUser;
  factory HiveService() {
    return _hiveService;
  }

  HiveService._internal();
  static Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    final appDocumentDir = await getDirectory();
    Hive.init(appDocumentDir.path);
    await adapterRegistration();
    _box = await Hive.openBox(_boxName);
    await setUsername();
  }

  static Future<Directory> getDirectory() async {
    return await path_provider.getApplicationDocumentsDirectory();
  }

  static Future<void> adapterRegistration() async {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(RoomAdapter());
  }

  static Future<void> saveUser(User user) async {
    await init();
    currentUser = user;
    await _box!.put('username', user);
  }

  static Future<void> setUsername() async {
    await init();
    currentUser = (_box!.get('username') as User?);
  }

  static Future<void> clearDB() async {
    await init();
    await _box!.delete('username');
  }
}
