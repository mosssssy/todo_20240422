import 'package:flutter/material.dart';
import 'package:todo_20240422/views/todo_all_list/add_task/add_task_page.dart';

class TodoAllListPage extends StatelessWidget {
  const TodoAllListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'みんなのタスク',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddTaskPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
