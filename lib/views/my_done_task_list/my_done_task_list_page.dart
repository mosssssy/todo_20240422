import 'package:flutter/material.dart';

class MyDoneTaskListPage extends StatelessWidget {
  const MyDoneTaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '完了済の自分のタスク',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
