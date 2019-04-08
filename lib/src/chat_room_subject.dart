import 'dart:html';
import 'dart:convert';

import 'package:dart_bulma_chat_app/src/helpers.dart';

class ChatRoomSubject {
  ChatRoomSubject(String url) : socket = WebSocket(url) {
    _initListeners();
  }

  final WebSocket socket;

  send(String data) => socket.send(data);

  close() => socket.close();

  _initListeners() {
    socket.onOpen.listen((evt) {
      print('Socket is open');
      send(encodeMessage(ActionTypes.newChat, null, null));
    });

    socket.onError.listen((evt) {
      print('Problems with socket. ${evt}');
    });

    socket.onClose.listen((evt) {
      print('Socket is closed');
    });
  }
}
