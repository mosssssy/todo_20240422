import 'package:flutter/material.dart';
import 'package:todo_20240422/views/my_done_task_list/my_done_task_list_page.dart';
import 'package:todo_20240422/views/my_page/my_page.dart';
import 'package:todo_20240422/views/todo_all_list/todo_all_list_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  List children = [
    const TodoAllListPage(),
    const MyDoneTaskListPage(),
    const MyPage(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int value) {
          currentIndex = value;
          setState(() {});
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MyPage',
          ),
        ],
      ),
    );
  }
}
