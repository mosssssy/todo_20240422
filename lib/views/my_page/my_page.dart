import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_20240422/common_widget/close_only_dialog.dart';
import 'package:todo_20240422/common_widget/confirm_dialog.dart';
import 'package:todo_20240422/common_widget/custom_font_size.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/data_models/user_data/userdata.dart';
import 'package:todo_20240422/functions/global_functions.dart';
import 'package:todo_20240422/views/my_page/components/blue_button.dart';
import 'package:todo_20240422/views/my_page/edit_emal/edit_email.dart';
import 'package:todo_20240422/views/my_page/edit_profile/edit_profile_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    String? myUserEmail = FirebaseAuth.instance.currentUser!.email;
    String? myUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'マイページ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                print('ログアウトしました');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(myUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasData == false) {
                  return const SizedBox.shrink();
                }
                final DocumentSnapshot<Map<String, dynamic>>? documentSnapshot =
                    snapshot.data;
                final Map<String, dynamic> userDataMap =
                    documentSnapshot!.data()!;
                final UserData userData = UserData.fromJson(userDataMap!);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (userData.imageUrl != '')
                      ClipOval(
                        child: Image.network(
                          userData.imageUrl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    else // imageUrlが空文字だったら
                      ClipOval(
                        child: Image.asset(
                          'assets/images/default_user_icon.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    MarginSizedBox.mediumHeightMargin,
                    Text(
                      userData.userName,
                      style: CustomFontSize.mediumFontSize,
                    ),
                    MarginSizedBox.smallHeightMargin,
                    Text(
                      ///三項演算子
                      (myUserEmail != null) ? myUserEmail : '',
                    ),
                    MarginSizedBox.bigHeightMargin,
                    BlueButton(
                      buttonText: 'メールアドレス変更',
                      onBlueButtonPressed: () async {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const EditEmailPage();
                        }));
                        //画面がpopしてmy_pageに返ってきたときに再度処理が走る
                        setState(() {});
                      },
                    ),
                    MarginSizedBox.smallHeightMargin,
                    BlueButton(
                      buttonText: 'パスワード変更',
                      onBlueButtonPressed: () async {
                        showConfirmDialog(
                          context: context,
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: myUserEmail!);
                              showToast("パスワードリセット用のメールを送信しました");
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } catch (e) {
                              showCloseOnlyDialog(
                                  context, e.toString(), 'メール送信失敗');
                            }
                          },
                          text: 'パスワード再設定メールを送信しますか？',
                        );
                      },
                    ),
                    MarginSizedBox.smallHeightMargin,
                    BlueButton(
                      buttonText: 'プロフィール編集',
                      onBlueButtonPressed: () {
                        print('プロフィール編集');
                        // 1) 指定した画面に遷移する
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditProfilePage(
                            userName: userData.userName,
                            imageUrl: userData.imageUrl,
                          );
                          // 2) 実際に表示するページを指定する
                        }));
                      },
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
