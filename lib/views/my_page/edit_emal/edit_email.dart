import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_20240422/common_widget/close_only_dialog.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/functions/global_functions.dart';
import 'package:todo_20240422/views/my_page/components/blue_button.dart';

class EditEmailPage extends StatelessWidget {
  const EditEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    String myUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController newEmailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    emailController.text = myUserEmail;
    return Scaffold(
      appBar: AppBar(title: const Text('メールアドレス変更')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                readOnly: true,
                controller: emailController,
                decoration: const InputDecoration(
                  label: Text('今のメールアドレス'),
                ),
              ),
              MarginSizedBox.smallHeightMargin,
              TextFormField(
                controller: newEmailController,
                decoration: const InputDecoration(
                  label: Text('新しいメールアドレス'),
                ),
                validator: (value) {
                  if (value == null || value == '') {
                    return '未入力です';
                  }
                  return null;
                },
              ),
              MarginSizedBox.smallHeightMargin,
              TextFormField(
                controller: passController,
                decoration: const InputDecoration(
                  label: Text('パスワード'),
                ),
                validator: (value) {
                  if (value == null || value == '') {
                    return '未入力です';
                  }
                  return null;
                },
              ),
              MarginSizedBox.bigHeightMargin,
              BlueButton(
                buttonText: 'メールアドレス変更',
                onBlueButtonPressed: () async {
                  try {
                    //まず一回ログインする
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text);
                    //メールアドレスを変更する
                    await FirebaseAuth.instance.currentUser!
                        .verifyBeforeUpdateEmail(newEmailController.text);
                    showToast('メールアドレス変更用のメールを送信しました');
                  } on FirebaseAuthException catch (error) {
                    print(error.code);
                    if (error.code == 'invalid-email') {
                      print('メールアドレスの形式ではありません');
                      showCloseOnlyDialog(
                          context, 'メールアドレスの形式ではありません', '失敗しました');
                    }
                    if (error.code == 'email-already-in-use') {
                      print('既に使われているメールアドレスです');
                      showCloseOnlyDialog(
                          context, '既に使われているメールアドレスです', '失敗しました');
                    }
                    if (error.code == 'weak-password') {
                      print('パスワードが弱すぎます');
                      showCloseOnlyDialog(context, 'パスワードが弱すぎます', '失敗しました');
                    }
                  } catch (error) {
                    showCloseOnlyDialog(context, error.toString(), '失敗しました');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
