import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'constants.dart';

class SocketService {
  late io.Socket _socket;

  void init() {
    _socket = io.io(AppConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.onConnect((_) {
      debugPrint('Socket Connected');
    });

    _socket.onDisconnect((_) {
      debugPrint('Socket Disconnected');
    });

    _socket.onConnectError((data) {
      debugPrint('Socket Connect Error: $data');
    });

    _socket.connect();
  }

  void on(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void off(String event) {
    _socket.off(event);
  }

  void dispose() {
    _socket.disconnect();
    _socket.dispose();
  }
}
