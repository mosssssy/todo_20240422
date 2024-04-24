import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_20240422/common_widget/close_only_dialog.dart';
import 'package:todo_20240422/common_widget/margin_sizedbox.dart';
import 'package:todo_20240422/functions/global_functions.dart';
import 'package:todo_20240422/views/my_page/components/blue_button.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({
    super.key,
    required this.userName,
    required this.imageUrl,
  });
  final String userName;
  String imageUrl;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;
  File? image; // 画像を入れる変数

  @override
  Widget build(BuildContext context) {
    userNameController.text = widget.userName;
    Widget previewWidget;
    if (image != null) {
      previewWidget = ClipOval(
        child: Image.file(
          image!,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    } else {
      if (widget.imageUrl != '') {
        // imageUrkが空文字のとき
        previewWidget = ClipOval(
          child: Image.network(
            widget.imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      } else {
        previewWidget = ClipOval(
            child: Image.asset(
          'assets/images/default_user_icon.png',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ));
      }
    }

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
                    Stack(
                      children: [
                        previewWidget,
                        if (widget.imageUrl != '')
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey, // 背景色を設定
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ), // アイコンを設定
                                onPressed: () async {
                                  // ボタンがタップされたときの処理
                                  // 画像削除
                                  // 上記で取得したURLを使ってUserドキュメントを更新する
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .update(
                                    {
                                      'imageUrl': '',
                                      'updatedAt': DateTime.now(),
                                    },
                                  );
                                  await FirebaseStorage.instance
                                      .ref('userIcon/${user.uid}')
                                      .delete();
                                  widget.imageUrl = '';
                                  showToast('画像削除しました');
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
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
                            return '未入力です';
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
                        try {
                          if (image != null) {
                            ///imageがnullじゃない
                            ///画像を選択したとき
                            ///ストレージに選択した画像をアップロードする
                            final storedImage = await FirebaseStorage.instance
                                .ref('userIcon/${user.uid}')
                                .putFile(image!);
                            //ストレージにあげた画像のURLを取得する
                            final String imageUrl =
                                await storedImage.ref.getDownloadURL();
                            //上記で取得したURLを使ってUserドキュメントを更新する
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .update(
                              {
                                'imageUrl': imageUrl,
                                'userName': userNameController.text,
                                'updatedAt': DateTime.now(),
                              },
                            );
                          } else {
                            ///imageがnull
                            ///画像を選択していないとき
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .update(
                              {
                                'userName': userNameController.text,
                                'updatedAt': DateTime.now(),
                              },
                            );
                          }
                          showToast('変更成功しました！');
                        } catch (error) {
                          showCloseOnlyDialog(
                              context, error.toString(), '更新失敗しました');
                        }
                      },
                    ),
                  ],
                ))));
  }

  Future getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); //アルバムから画像を取得

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
}
