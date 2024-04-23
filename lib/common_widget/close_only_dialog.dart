import 'package:flutter/material.dart';

void showCloseOnlyDialog(context, text, title) {
  showDialog(
    context: context,
    builder: (context) {
      return CloseOnlyDialog(
        text: text,
        title: title,
      );
    },
  );
}

class CloseOnlyDialog extends StatelessWidget {
  const CloseOnlyDialog({
    super.key,
    required this.text,
    required this.title,
  });
  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
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
