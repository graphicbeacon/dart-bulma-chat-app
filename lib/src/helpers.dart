import 'dart:convert';

enum ActionTypes { newChat, chatMessage, leaveChat }

ActionTypes getActionType(String typeStr) {
  ActionTypes matchedActionType;
  ActionTypes.values.forEach((actionType) {
    if (actionType.toString() == typeStr) {
      matchedActionType = actionType;
    }
  });
  return matchedActionType;
}

encodeMessage(ActionTypes type, String from, String message) => json.encode({
      'type': type.toString(),
      'from': from,
      'data': message,
    });

decodeMessage(String message) {
  var decoded = json.decode(message);
  return {
    'type': getActionType(decoded['type']),
    'from': decoded['from'],
    'data': decoded['data'],
  };
}
