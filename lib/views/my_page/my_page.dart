import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_20240422/common_widget/custom_font_size.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/data_models/user_data/userdata.dart';
import 'package:todo_20240422/views/my_page/components/blue_button.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? myUserEmail = FirebaseAuth.instance.currentUser!.email;
    final String myUserId = FirebaseAuth.instance.currentUser!.uid;
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
                      onBlueButtonPressed: () {
                        print('メールアドレス変更');
                      },
                    ),
                    MarginSizedBox.smallHeightMargin,
                    BlueButton(
                      buttonText: 'パスワード変更',
                      onBlueButtonPressed: () {
                        print('パスワード変更');
                      },
                    ),
                    MarginSizedBox.smallHeightMargin,
                    BlueButton(
                      buttonText: 'プロフィール編集',
                      onBlueButtonPressed: () {
                        print('プロフィール編集');
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
