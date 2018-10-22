import 'dart:io';
import 'dart:convert';

main() async {
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9780 : portEnv;
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);

  print('Server listening on port $port');

  await for (HttpRequest request in server) {
    // TODO: Remove only temporary
    request.response.headers
        .add('Access-Control-Allow-Origin', 'http://localhost:8080');

    print('[Incoming request]: ${request.uri.path} ${request.session.id}');
    // TODO: Set static server to respond with index.html file

    if (request.uri.path == '/signin') {
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
    }
  }
}
