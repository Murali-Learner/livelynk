import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:livelynk/services/routes.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class HomeSocket {
  HomeSocket._({
    required this.url,
  });

  static HomeSocket instance = HomeSocket._(url: APIRoutes.baseUrl);

  /// Websocket URL.
  final String url;

  Function? onOpen;
  Function? onClose;
  Function? onFailed;
  Function(dynamic joinedUserId)? onJoinedRoom;
  Function(dynamic)? onReceivedMessage;
  Function(String method, dynamic data)? onRequest;
  Function(String method, dynamic data)? onNotification;

  /// [Socket] instance which will be used as communication channel between
  /// socket server and the app
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  void init() {
    if (socket != null && socket?.connected == true) {
      log("Home Socket CLOSED");
      close();
    }

    final optionBuilder = io.OptionBuilder().setTransports([
      'websocket',
      'polling',
    ]);

    _socket = io.io(url, optionBuilder.build());

    _socket?.onAny((event, data) {
      if (kDebugMode) {
        log("on: $event, $data", name: "HOME SOCKET");
      }
    });
    _socket?.on('open', (_) => onOpen?.call());
    _socket?.on('failed', (data) => onFailed?.call());
    _socket?.on("joinedRoom", (data) => onJoinedRoom?.call(data));
    _socket?.on("receiveMessage", (data) => onReceivedMessage?.call(data));

    _socket?.on("connect_timeout",
        (data) => {print("connect_timeout          ${data.toString()}")});
    _socket?.onDisconnect((data) => onClose?.call());
  }

  void connect() => _socket?.connect();
  void close() => _socket?.close();
}
