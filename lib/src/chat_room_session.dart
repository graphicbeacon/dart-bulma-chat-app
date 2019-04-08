import 'dart:io';
import 'dart:convert';

import 'helpers.dart';

class Chatter {
  Chatter({this.session, this.socket, this.name});
  HttpSession session;
  WebSocket socket;
  String name;
}

class ChatRoomSession {
  final List<Chatter> _chatters = [];

  // Add chatter
  addChatter(HttpRequest request, String username) async {
    WebSocket ws = await WebSocketTransformer.upgrade(request);
    Chatter chatter = Chatter(
      session: request.session,
      socket: ws,
      name: username,
    );

    chatter.socket.listen(
      (data) => _handleMessage(chatter, data),
      onError: (err) => print('Error with socket ${err.message}'),
      onDone: () => _removeChatter(chatter),
    );

    _chatters.add(chatter);

    print('[ADDED CHATTER]: ${chatter.name}');
  }

  _handleMessage(Chatter chatter, data) {
    print('[INCOMING MESSAGE]: $data');

    // Decode and check action types of payload
    Map<String, dynamic> decoded = json.decode(data);
    var actionType = getActionType(decoded['type']);
    var message = decoded['data'];

    switch (actionType) {
      case ActionTypes.newChat:
        chatter.socket.add(encodeMessage(
          ActionTypes.newChat,
          null,
          'Welcome to the chat ${chatter.name}',
        ));
        _notifyChatters(
          ActionTypes.newChat,
          chatter,
          '${chatter.name} has joined the chat.',
        );
        break;
      case ActionTypes.chatMessage:
        chatter.socket.add(encodeMessage(
          ActionTypes.chatMessage,
          'You',
          message,
        ));
        _notifyChatters(ActionTypes.chatMessage, chatter, message);
        break;
      case ActionTypes.leaveChat:
        chatter.socket.close();
        break;
      default:
        break;
    }
  }

  _removeChatter(Chatter chatter) {
    print('[REMOVING CHATTER]: ${chatter.name}');
    _chatters.removeWhere((c) => c.name == chatter.name);
    _notifyChatters(
      ActionTypes.leaveChat,
      chatter,
      '${chatter.name} has left the chat.',
    );
  }

  _notifyChatters(ActionTypes actionType, Chatter exclude, [String message]) {
    var from =
        actionType == ActionTypes.newChat || actionType == ActionTypes.leaveChat
            ? null
            : exclude.name;

    _chatters
        .where((chatter) => chatter.name != exclude.name)
        .toList()
        .forEach((chatter) => chatter.socket.add(encodeMessage(
              actionType,
              from,
              message,
            )));
  }
}
