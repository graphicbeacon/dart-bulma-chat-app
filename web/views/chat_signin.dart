// Absolute imports
import 'dart:html';

// Relative imports
import './view.dart';
import '../router.dart';

class ChatSigninView implements View {
  ChatSigninView() : _contents = DocumentFragment() {
    onEnter();
  }

  /// Properties
  DocumentFragment _contents;
  DivElement chatSigninBox;
  ParagraphElement validationBox;
  InputElement nameField;
  ButtonElement submitBtn;
  HttpRequest _response;

  @override
  void onEnter() {
    prepare();
    render();
  }

  @override
  void onExit() {
    nameField.removeEventListener('input', _inputHandler);
    submitBtn.removeEventListener('click', _clickHandler);

    // Swap view to chat room
    router.go('/chat-room', params: {'username': _response.responseText});
  }

  @override
  void prepare() {
    _contents.innerHtml = '''
    <div id="ChatSignin">
      <h1 class="title">Chatter 🎯</h1>
      <div class="columns">
        <div class="column is-6">
          <div class="field">
            <label class="label">Please enter your name</label>
            <div class="control is-expanded has-icons-left">
              <input class="input is-medium" type="text" placeholder="Enter your name and hit ENTER" />
              <span class="icon is-medium is-left">
                <i class="fas fa-user"></i>
              </span>
            </div>
            <p class="help is-danger"></p>
          </div>
          <div class="field">
            <div class="control">
              <button class="button is-medium is-primary">
                Join chat
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    ''';

    chatSigninBox = _contents.querySelector('#ChatSignin');
    validationBox = chatSigninBox.querySelector('p.help');
    nameField = chatSigninBox.querySelector('input[type="text"]');
    submitBtn = chatSigninBox.querySelector('button');

    _addEventListeners();
  }

  @override
  render() {
    querySelector('#app')
      ..innerHtml = ''
      ..append(_contents);
  }

  void _addEventListeners() {
    // Event listeners on form controls
    nameField.addEventListener('input', _inputHandler);
    submitBtn.addEventListener('click', _clickHandler);
  }

  void _inputHandler(evt) {
    if (nameField.value.trim().isNotEmpty) {
      nameField.classes
        ..removeWhere((className) => className == 'is-danger')
        ..add('is-success');
      validationBox.text = '';
    } else {
      nameField.classes
        ..removeWhere((className) => className == 'is-success')
        ..add('is-danger');
    }
  }

  void _clickHandler(evt) async {
    // Validate name field
    if (nameField.value.trim().isEmpty) {
      nameField.classes.add('is-danger');
      validationBox.text = 'Please enter your name';
      return;
    }

    submitBtn.disabled = true;

    // Submit name to backend via POST
    try {
      _response = await HttpRequest.postFormData(
        'http://localhost:9780/signin',
        {
          'username': nameField.value,
        },
      );

      // Handle success response and switch view
      onExit();
    } catch (e) {
      // Handle failure response
      submitBtn
        ..disabled = false
        ..text = 'Failed to join chat. Try again?';
    }
  }
}
