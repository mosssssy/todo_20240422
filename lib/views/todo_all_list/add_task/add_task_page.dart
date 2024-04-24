import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/data_models/user_data/todo/todo.dart';
import 'package:todo_20240422/functions/global_functions.dart';
import 'package:todo_20240422/views/my_page/components/blue_button.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController taskNameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: taskNameController,
                maxLength: 20,
                validator: (value) {
                  if (value == null || value == '') {
                    return '未入力です';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text('タスク名'),
                ),
              ),
              MarginSizedBox.bigHeightMargin,
              BlueButton(
                buttonText: 'タスクを追加する',
                onBlueButtonPressed: () async {
                  if (formKey.currentState!.validate() == false) {
                    return;
                  }
                  Todo addTodoData = Todo(
                    taskName: taskNameController.text,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    createdAt: Timestamp.now(),
                    updatedAt: Timestamp.now(),
                  );
                  await FirebaseFirestore.instance
                      .collection('todos')
                      .add(addTodoData.toJson());
                  showToast('タスクが追加されました');
                  taskNameController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
