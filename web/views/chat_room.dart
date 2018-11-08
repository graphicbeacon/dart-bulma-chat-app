// Absolute imports
import 'dart:html';

// Relative imports
import './view.dart';
import '../router.dart';

class ChatRoomView implements View {
  ChatRoomView(this.params) : _contents = DocumentFragment() {
    onEnter();
  }

  /// Properties
  Map params;
  DocumentFragment _contents;
  DivElement chatRoomBox;
  DivElement chatRoomLog;
  InputElement messageField;
  ButtonElement sendBtn;

  @override
  void onEnter() {
    prepare();
    render();
  }

  @override
  void onExit() {
    _removeEventListeners();

    router.go('/');
  }

  @override
  void prepare() {
    _contents.innerHtml = '''
    <div id="ChatRoom">
        <h1 class="title">Chatroom</h1>
        <div class="tile is-ancestor">
          <div class="tile is-8 is-vertical is-parent">
            <div class="tile is-child box">
              <div id="ChatRoomLog"></div>
            </div>
            <div class="tile is-child">
              <div class="field has-addons">
                <div class="control is-expanded has-icons-left">
                  <input id="ChatRoomMessageInput" class="input is-medium" type="text" placeholder="Enter message" />
                  <span class="icon is-medium is-left">
                    <i class="fas fa-keyboard"></i>
                  </span>
                </div>
                <div class="control">
                  <button id="ChatRoomSendBtn" class="button is-medium is-primary">
                    Send&nbsp;&nbsp;
                    <span class="icon is-medium">
                      <i class="fas fa-paper-plane"></i>
                    </span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      ''';

    chatRoomBox = _contents.querySelector('#ChatRoom');
    chatRoomLog = chatRoomBox.querySelector('#ChatRoomLog');
    messageField = chatRoomBox.querySelector('#ChatRoomMessageInput');
    sendBtn = chatRoomBox.querySelector('#ChatRoomSendBtn');

    _addEventListeners(); // TODO: Implement this method next
  }

  @override
  render() {
    querySelector('#app')
      ..innerHtml = ''
      ..append(_contents);
  }

  void _addEventListeners() {
    sendBtn.disabled = true;

    /// Event listeners
    messageField.addEventListener('input', _messageFieldInputHandler);
    sendBtn.addEventListener('click', _sendBtnClickHandler);
  }

  void _removeEventListeners() {
    messageField.removeEventListener('input', _messageFieldInputHandler);
    sendBtn.removeEventListener('click', _sendBtnClickHandler);
  }

  void _messageFieldInputHandler(e) {
    // Disable the send button if message input is empty
    sendBtn.disabled = messageField.value.isEmpty;
  }

  void _sendBtnClickHandler(e) {
    // TODO: Broadcast message to other chat users
    messageField.value = '';
  }
}
