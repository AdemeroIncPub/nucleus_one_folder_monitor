import 'package:flutter/material.dart';

Future<String?> showTextInputDialog(
  BuildContext context, {
  BoxConstraints? contentConstraints,
  String? text,
  Widget? title,
  String? labelText,
  String? helperText,
  String? hintText,
}) async {
  final textFieldController = TextEditingController();
  textFieldController.text = text ?? '';

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
