import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/views/auth/components/auth_text_form_field.dart';

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
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'パスワードを忘れた方はこちら >',
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.end,
                ),
              ),
              MarginSizedBox.bigHeightMargin,
              ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
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
                      }
                    } on FirebaseAuthException catch (error) {
                      print(error.code);
                      if (error.code == 'email-already-in-use') {
                        print('すでに使われているメールアドレスです');
                      }
                      if (error.code == 'weak-password') {
                        print('パスワードが弱すぎます');
                      }
                    } catch (error) {
                      print('予期せぬエラーです');
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    '会員登録',
                    style: TextStyle(color: Colors.white),
                  )),
              MarginSizedBox.smallHeightMargin,
              ElevatedButton(
                  onPressed: () async {
                    if (!formkey.currentState!.validate()) {
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
                      } else {
                        print('ログイン失敗');
                      }
                    } catch (e) {
                      //
                    }
                  },
                  child: const Text(
                    'ログイン',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class smallSizedbox {
  const smallSizedbox();
}
