import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_20240422/common_widget/close_only_dialog.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/views/auth/components/auth_text_form_field.dart';
import 'package:todo_20240422/main.dart';
import 'package:todo_20240422/views/auth/password_reminder_page.dart';
import 'package:todo_20240422/views/bottom_navigation/bottom_navigation_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthTextFormField(
                controller: emailController,
                label: 'メールアドレス',
              ),
              MarginSizedBox.smallHeightMargin,
              AuthTextFormField(
                controller: passController,
                label: 'パスワード',
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    // 1) 指定した画面に遷移する
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const PasswordReminderPage();
                      // 2) 実際に表示するページを指定する
                    }));
                  },
                  child: const Text(
                    'パスワードを忘れた方はこちら >',
                    style: TextStyle(color: Colors.deepPurple),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              MarginSizedBox.bigHeightMargin,
              ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate() == false) {
                      // 失敗時に処理ストップ
                      return;
                    }
                    // 成功
                    try {
                      final User? user = (await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passController.text))
                          .user;
                      if (user != null) {
                        print('ユーザーを登録しました');
                        // FirebaseStore に userドキュメントを作成
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .set({
                          'userName': '',
                          'imageUrl': '',
                          'createdAt': DateTime.now(),
                          'updatedAt': DateTime.now(),
                        });
                        AlertDialog(
                          title: const Text("会員登録成功"),
                          content: const Text('ユーザーを登録しました'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("close"),
                            )
                          ],
                        );
                      } else {
                        showCloseOnlyDialog(
                            context, '予期せぬエラーが出ました。\nやり直してください。');
                      }
                    } on FirebaseAuthException catch (error) {
                      if (error.code == 'invalid-email') {
                        print('メールアドレスの形式ではありません');
                        showCloseOnlyDialog(context, 'メールアドレスの形式ではありません');
                      }
                      if (error.code == 'email-already-in-use') {
                        print('すでに使われているメールアドレスです');
                        showCloseOnlyDialog(context, '既に使われているメールアドレスです');
                      }
                      if (error.code == 'weak-password') {
                        print('パスワードが弱すぎます');
                        showCloseOnlyDialog(context, 'パスワードが弱すぎます');
                      }
                    } catch (error) {
                      print('予期せぬエラーです');
                      showCloseOnlyDialog(context, '予期せぬエラーが出ました。\nやり直してください。');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  child: const Text(
                    '会員登録',
                    style: TextStyle(color: Colors.white),
                  )),
              MarginSizedBox.smallHeightMargin,
              ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate() == false) {
                      return;
                    }
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User? user = (await auth.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text,
                      ))
                          .user;
                      if (user != null) {
                        print('ログイン成功');
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({
                          'updatedAt': DateTime.now(),
                        });
                      } else {
                        print('ログイン失敗');
                        showCloseOnlyDialog(
                            context, '予期せぬエラーが出ました。\n再度やり直してください。');
                      }
                    } on FirebaseAuthException catch (error) {
                      if (error.code == 'user-not-found') {
                        showCloseOnlyDialog(context, 'ユーザーが見つかりません');
                      } else if (error.code == 'invalid-email') {
                        showCloseOnlyDialog(context, 'メールアドレスの形式ではありません');
                      }
                    } catch (error) {
                      showCloseOnlyDialog(context, '予期せぬエラーがきたよ。$error');
                    }
                  },
                  child: const Text(
                    'ログイン',
                    style: TextStyle(color: Colors.deepPurple),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
