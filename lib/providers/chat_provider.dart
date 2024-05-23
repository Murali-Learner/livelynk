import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../services/socket_service.dart';

class ChatProvider with ChangeNotifier {
  final SocketService socketService;
  WebSocketChannel? _channel;
  List<String> _messages = [];

  ChatProvider(this.socketService);

  List<String> get messages => _messages;

  void joinRoom(String roomId) {
    _channel = socketService.joinRoom(roomId);
    _channel?.stream.listen((message) {
      _messages.add(message);
      notifyListeners();
    });
  }

  void sendMessage(String message) {
    if (_channel != null) {
      socketService.sendMessage(_channel!, message);
    }
  }

  @override
  void dispose() {
    if (_channel != null) {
      socketService.close(_channel!);
    }
    super.dispose();
  }
}
