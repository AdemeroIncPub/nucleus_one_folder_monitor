import 'package:flutter/material.dart';

Future<String?> showTextInputDialog(
  BuildContext context, {
  BoxConstraints? contentConstraints,
  Widget? title,
  String? initialText,
  String? labelText,
  String? helperText,
  String? hintText,
}) async {
  final textFieldController = TextEditingController();
  textFieldController.text = initialText ?? '';

  void submitHandler(BuildContext context, String text) {
    Navigator.pop(context, textFieldController.text);
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        content: Container(
          constraints: contentConstraints,
          child: TextField(
            autofocus: true,
            controller: textFieldController,
            decoration: InputDecoration(
              hintText: hintText,
              helperText: helperText,
              labelText: labelText,
            ),
            onSubmitted: (value) => submitHandler(context, value),
          ),
        ),
        actionsAlignment: MainAxisAlignment.start,
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            onPressed: () => submitHandler(context, textFieldController.text),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  Widget? title,
  String? contentText,
  Widget? contentWidget,
  String falseText = 'CANCEL',
  String trueText = 'OK',
  bool dangerous = false,
}) {
  assert([contentText, contentWidget].where((x) => x != null).length == 1);

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        content: contentWidget ?? Text(contentText!),
        actionsAlignment: MainAxisAlignment.start,
        actions: <Widget>[
          TextButton(
            child: Text(falseText),
            onPressed: () => Navigator.pop(context, false),
          ),
          if (dangerous)
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error),
              onPressed: () => Navigator.pop(context, true),
              child: Text(trueText),
            )
          else
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(trueText),
            ),
        ],
      );
    },
  );
}
