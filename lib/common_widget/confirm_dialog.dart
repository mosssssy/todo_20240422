import 'package:flutter/material.dart';

void showConfirmDialog(
    {required BuildContext context,
    required String text,
    required VoidCallback onPressed}) {
  showDialog(
    context: context,
    builder: (context) {
      return ConfirmDialog(
        text: text,
        onPressed: onPressed,
      );
    },
  );
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('確認'),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text("はい"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("いいえ"),
        ),
      ],
    );
  }
}
