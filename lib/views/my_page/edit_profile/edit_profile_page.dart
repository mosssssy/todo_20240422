import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/functions/global_functions.dart';
import 'package:todo_20240422/views/my_page/components/blue_button.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({
    super.key,
    required this.userName,
  });
  final String userName;

  @override
  Widget build(BuildContext context) {
    print(userName);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController userNameController = TextEditingController();
    final User user = FirebaseAuth.instance.currentUser!;
    userNameController.text = userNameController.text;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'プロフィール編集',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                        controller: userNameController,
                        maxLength: 12,
                        validator: (value) {
                          if (value == null || value == '') {
                            return '未入力ですよ';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(label: Text('ユーザーネーム'))),
                    MarginSizedBox.bigHeightMargin,
                    BlueButton(
                      buttonText: 'プロフィールを変更する',
                      onBlueButtonPressed: () async {
                        if (formKey.currentState!.validate() == false) {
                          return;
                        }
                        //バリデーション突破したあとの処理を下に書く
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update(
                          {
                            'userName': userNameController.text,
                          },
                        );
                        showToast('変更成功しました！');
                      },
                    ),
                  ],
                ))));
  }
}
