import './router.dart';
import './views/chat_room.dart';
import './views/chat_signin.dart';

void main() {
  router
    ..register('/', (_) => ChatSigninView())
    ..register('/chat-room', (params) => ChatRoomView(params))
    ..go('/');
}
