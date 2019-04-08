import 'dart:io';
import 'dart:convert';

import 'package:dart_bulma_chat_app/src/chat_room_session.dart';

main() async {
  // TODO: Get port from environment variable
  var port = 9780;
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  var chatRoomSession = ChatRoomSession();

  print('Server listening on port $port');

  await for (HttpRequest request in server) {
    // TODO: Remove only temporary
    request.response.headers
        .add('Access-Control-Allow-Origin', 'http://localhost:8084');

    print('[Incoming request]: ${request.uri.path} ${request.session.id}');

    switch (request.uri.path) {
      case '/signin':
        String payload = await request.transform(Utf8Decoder()).join();
        var username = Uri.splitQueryString(payload)['username'];
        if (username != null && username.isNotEmpty) {
          // TODO: Check username is unique
          request.response
            ..write(username)
            ..close();
        } else {
          request.response
            ..statusCode = 400
            ..write('Please provide a valid user name')
            ..close();
        }
        break;
      case '/ws':
        String username = request.uri.queryParameters['username'];
        chatRoomSession.addChatter(request, username);
        break;
      default:
      // TODO: Forward to static file server
    }
  }
}
