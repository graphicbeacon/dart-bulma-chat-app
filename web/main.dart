import 'dart:html';

void main() {
  /// Selectors
  var chatLoginBox = querySelector('#ChatLogin');
  var chatRoomBox = querySelector('#ChatRoom');
  var validationBox = chatLoginBox.querySelector('p.help');
  InputElement nameField = chatLoginBox.querySelector('input[type="text"]');
  ButtonElement submitBtn = chatLoginBox.querySelector('button');

  /// Event listeners
  nameField.addEventListener('input', (evt) {
    if (nameField.value.trim().isNotEmpty) {
      nameField.classes
        ..removeWhere((className) => className == 'is-danger')
        ..add('is-success');
      validationBox.text = '';
    } else {
      nameField.classes.removeWhere((className) => className == 'is-success');
    }
  });

  submitBtn.addEventListener('click', (evt) async {
    // Validate name field
    if (nameField.value.trim().isEmpty) {
      nameField.classes.add('is-danger');
      validationBox.text = 'Please enter your name';
      return;
    }

    submitBtn.disabled = true;

    // Submit name to backend via POST
    try {
      var response = await HttpRequest.postFormData(
        'http://localhost:9780/signin',
        {
          'username': nameField.value,
        },
      );

      // Handle success response and switch view
      chatLoginBox.hidden = true;
      chatRoomBox.hidden = false;
    } catch (e) {
      // Handle failure response
      submitBtn
        ..disabled = false
        ..text = 'Failed to join chat. Try again?';
    }
  });
}
