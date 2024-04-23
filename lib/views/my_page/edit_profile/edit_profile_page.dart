import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/functions/global_functions.dart';
import 'package:todo_20240422/views/my_page/components/blue_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.userName,
  });
  final String userName;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    userNameController.text = widget.userName;
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
                    MarginSizedBox.mediumHeightMargin,
                    BlueButton(
                      buttonText: '画像を選択する',
                      onBlueButtonPressed: () {
                        //Image Pickerをインスタンス化
                        getImageFromGallery();
                      },
                    ),
                    MarginSizedBox.mediumHeightMargin,
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

  Future getImageFromGallery() async {
    File? image; //画像を入れる変数
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); //アルバムから画像を取得

    if (pickedFile != null) {
      image = File(pickedFile.path);
      print(image);
    }
    setState(() {});
  }

  // Future getImageFromCamera() async {
  //   final pickedFile =
  //       await picker.pickImage(source: ImageSource.camera); //カメラから画像を取得
  //   setState(() {
  //     //画面を再読込
  //     if (pickedFile != null) {
  //       //画像を取得できたときのみ実行
  //       image = File(pickedFile.path); //取得した画像を代入
  //     }
  //   });
  // }
}
