import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  final String baseUrl;

  SocketService(this.baseUrl);

  WebSocketChannel joinRoom(String roomId) {
    final channel = IOWebSocketChannel.connect('$baseUrl/$roomId');
    return channel;
  }

  void sendMessage(WebSocketChannel channel, String message) {
    channel.sink.add(message);
  }

  void close(WebSocketChannel channel) {
    channel.sink.close();
  }
}
