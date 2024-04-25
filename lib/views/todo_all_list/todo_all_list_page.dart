import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_20240422/common_widget/confirm_dialog.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/data_models/user_data/todo/todo.dart';
import 'package:todo_20240422/data_models/user_data/userdata.dart';
import 'package:todo_20240422/functions/global_functions.dart';
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('todos')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData == false || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          // 目標形： [{}, {}, {}]
          // 現在：   ⭕️💎[{}, {}, {}]💎⭕️
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              snapshot.data!;
          // 現在：   💎[{}, {}, {}]💎
          final List<QueryDocumentSnapshot<Map<String, dynamic>>> listData =
              querySnapshot.docs;
          // 現在：   [🐶{}🐶, 🐶{}🐶, 🐶{}🐶]
          return ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot<Map<String, dynamic>>
                  queryDocumentSnapshot = listData[index];
              Map<String, dynamic> mapData = queryDocumentSnapshot.data();
              // ゴール！： [{}, {}, {}]
              Todo todo = Todo.fromJson(mapData);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(todo.userId)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            userSnapshot) {
                      if (userSnapshot.hasData == false ||
                          userSnapshot.data == null) {
                        return Container();
                      }
                      final DocumentSnapshot<Map<String, dynamic>>
                          documentSnapshot = userSnapshot.data!;
                      final Map<String, dynamic> userMap =
                          documentSnapshot.data()!;
                      final UserData postUser = UserData.fromJson(userMap);
                      return Slidable(
                        // Specify a key if the Slidable is dismissible.
                        key: const ValueKey(0),
                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (context) {
                                FirebaseFirestore.instance
                                    .collection('todos')
                                    .doc(todo.todoId)
                                    .update({
                                  'isCompleted': true,
                                });
                              },
                              backgroundColor: Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.archive,
                              label: '完了済み',
                            ),
                          ],
                        ),

                        // The child of the Slidable is what the user sees when the
                        // component is not dragged.
                        child: ListTile(
                          onTap: () {},
                          leading: (postUser.imageUrl != '')
                              ? ClipOval(
                                  child: Image.network(
                                    postUser.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              :
                              //imageUrlが空文字だったら
                              ClipOval(
                                  child: Image.asset(
                                    'assets/images/default_user_icon.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          title: Text(todo.taskName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(postUser.userName),
                                  MarginSizedBox.smallWidthMargin,
                                  Text(
                                    todo.createdAt
                                        .toDate()
                                        .toString()
                                        .substring(0, 16),
                                  ),
                                ],
                              ),
                              Text((todo.isCompleted) ? '完了済み' : '未完了'),
                            ],
                          ),
                          trailing: (todo.userId ==
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? IconButton(
                                  onPressed: () {
                                    showConfirmDialog(
                                        context: context,
                                        text: '本当に削除しますか？',
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await FirebaseFirestore.instance
                                              .collection('todos')
                                              .doc(todo.todoId)
                                              .delete();
                                          showToast('削除成功しました');
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }),
              );
            },
          );
        },
      ),
    );
  }
}
