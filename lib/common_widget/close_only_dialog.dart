import 'package:flutter/material.dart';

void showCloseOnlyDialog(context, text) {
  showDialog(
    context: context,
    builder: (context) {
      return CloseOnlyDialog(
        text: text,
      );
    },
  );
}

class CloseOnlyDialog extends StatelessWidget {
  const CloseOnlyDialog({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("会員登録失敗"),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("close"),
        )
      ],
    );
  }
}
