// Absolute imports
import 'dart:html';
import 'dart:convert';

// Package imports
import 'package:dart_bulma_chat_app/src/chat_room_subject.dart';
import 'package:dart_bulma_chat_app/src/helpers.dart';

// Relative imports
import './view.dart';
import '../router.dart';

class ChatRoomView implements View {
  ChatRoomView(this.params)
      : _contents = DocumentFragment(),
        _subject = ChatRoomSubject(params['username']) {
    onEnter();
  }

  /// Properties
  final ChatRoomSubject _subject;
  final Map params;
  DocumentFragment _contents;
  DivElement chatRoomBox;
  DivElement chatRoomLog;
  InputElement messageField;
  ButtonElement sendBtn;
  ButtonElement leaveBtn;

  @override
  void onEnter() {
    prepare();
    render();
  }

  @override
  void onExit() {
    _removeEventListeners();
    _subject.close();

    router.go('/');
  }

  @override
  void prepare() {
    _contents.innerHtml = '''
    <div id="ChatRoom">
        <div class="columns">
          <div class="column is-two-thirds-mobile is-two-thirds-desktop">
            <h1 class="title">Chatroom</h1>
          </div>
          <div class="column has-text-right">
            <button
              id="ChatRoomLeaveBtn"
              class="button is-warning">Leave Chat</button>
          </div>
        </div>
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
    leaveBtn = chatRoomBox.querySelector('#ChatRoomLeaveBtn');

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
    _subject.socket.onMessage.listen(_subjectMessageHandler);
    leaveBtn.addEventListener('click', _leaveBtnClickHandler);
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
    _subject.send(encodeMessage(
      ActionTypes.chatMessage,
      params['username'],
      messageField.value,
    ));

    // Empty and re-focus on message box
    messageField
      ..value = ''
      ..focus();
  }

  void _leaveBtnClickHandler(e) {
    _subject.close();
    router.go('/');
  }

  void _subjectMessageHandler(evt) {
    var decoded = decodeMessage(evt.data);
    var from = decoded['from'];
    var message = decoded['data'];
    var str = StringBuffer();

    if (from == null) {
      str.write('''
      <div class="tags">
        <p class="tag is-light is-normal">$message</p>
      </div>
      ''');
    } else {
      str.write('''
        <div class="tags has-addons">
          <span class="tag ${from == 'You' ? 'is-primary' : 'is-dark'}">$from said:</span>
          <span class="tag is-light">$message</span>
        </div>
      ''');
    }

    chatRoomLog.appendHtml(str.toString());
  }
}
