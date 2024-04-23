import 'package:flutter/material.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/views/auth/components/auth_text_form_field.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    final TextEditingController emailcontroller = TextEditingController();
    final TextEditingController passcontroller = TextEditingController();

    return Scaffold(
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthTextFormField(
                controller: emailcontroller,
                label: 'メールアドレス',
              ),
              MarginSizedBox.smallHeightMargin,
              AuthTextFormField(
                controller: passcontroller,
                label: 'パスワード',
              ),
              MarginSizedBox.bigHeightMargin,
              ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      // 成功
                    } else {
                      // 失敗
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    '会員登録',
                    style: TextStyle(color: Colors.white),
                  )),
              MarginSizedBox.smallHeightMargin,
              ElevatedButton(
                  onPressed: () {},
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
