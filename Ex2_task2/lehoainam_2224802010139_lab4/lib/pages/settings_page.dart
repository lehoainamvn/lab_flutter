import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';
import '../providers/setting_provider.dart';
import '../widgets/loading_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController? controllerNickname;
  TextEditingController? controllerAboutMe;

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';

  bool isLoading = false;
  File? avatarImageFile;
  late SettingProvider settingProvider;

  final FocusNode focusNodeNickname = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  @override
  void initState() {
    super.initState();
    settingProvider = context.read<SettingProvider>();
    readLocal();
  }

  void readLocal() {
    setState(() {
      id = settingProvider.getPref(FirestoreConstants.id) ?? "";
      nickname = settingProvider.getPref(FirestoreConstants.nickname) ?? "";
      aboutMe = settingProvider.getPref(FirestoreConstants.aboutMe) ?? "";
      photoUrl = settingProvider.getPref(FirestoreConstants.photoUrl) ?? "";
    });

    controllerNickname = TextEditingController(text: nickname);
    controllerAboutMe = TextEditingController(text: aboutMe);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
      return null;
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;
    UploadTask uploadTask = settingProvider.uploadFile(avatarImageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      settingProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, id, {
        FirestoreConstants.nickname: nickname,
        FirestoreConstants.aboutMe: aboutMe,
        FirestoreConstants.photoUrl: photoUrl
      }).then((data) async {
        await settingProvider.setPref(FirestoreConstants.photoUrl, photoUrl);
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Upload success");
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });
    settingProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, id, {
      FirestoreConstants.nickname: nickname,
      FirestoreConstants.aboutMe: aboutMe,
      FirestoreConstants.photoUrl: photoUrl
    }).then((data) async {
      await settingProvider.setPref(FirestoreConstants.nickname, nickname);
      await settingProvider.setPref(FirestoreConstants.aboutMe, aboutMe);
      await settingProvider.setPref(FirestoreConstants.photoUrl, photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: TextStyle(color: ColorConstants.primaryColor),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Avatar
                Container(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        avatarImageFile == null
                            ? photoUrl.isNotEmpty
                                ? Material(
                                    child: Image.network(
                                      photoUrl,
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                      errorBuilder: (context, object, stackTrace) {
                                        return const Icon(
                                          Icons.account_circle,
                                          size: 150,
                                          color: ColorConstants.greyColor,
                                        );
                                      },
                                      loadingBuilder:
                                          (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          width: 150,
                                          height: 150,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: ColorConstants.themeColor,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(75)),
                                    clipBehavior: Clip.hardEdge,
                                  )
                                : const Icon(
                                    Icons.account_circle,
                                    size: 150,
                                    color: ColorConstants.greyColor,
                                  )
                            : Material(
                                child: Image.file(
                                  avatarImageFile!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(75)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: ColorConstants.primaryColor,
                          ),
                          onPressed: getImage,
                          padding: const EdgeInsets.all(30),
                          splashColor: Colors.transparent,
                          highlightColor: ColorConstants.greyColor,
                          iconSize: 30,
                        ),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                ),

                // Input
                Column(
                  children: <Widget>[
                    // Nickname
                    Container(
                      child: const Text(
                        'Nickname',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: ColorConstants.primaryColor),
                      ),
                      margin: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context).copyWith(primaryColor: ColorConstants.primaryColor),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Shayne',
                            contentPadding: EdgeInsets.all(5),
                            hintStyle: TextStyle(color: ColorConstants.greyColor),
                          ),
                          controller: controllerNickname,
                          onChanged: (value) {
                            nickname = value;
                          },
                          focusNode: focusNodeNickname,
                        ),
                      ),
                      margin: const EdgeInsets.only(left: 30, right: 30),
                    ),

                    // About me
                    Container(
                      child: const Text(
                        'About me',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: ColorConstants.primaryColor),
                      ),
                      margin: const EdgeInsets.only(left: 10, bottom: 5, top: 30),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context).copyWith(primaryColor: ColorConstants.primaryColor),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Fun, like travel and play game...',
                            contentPadding: EdgeInsets.all(5),
                            hintStyle: TextStyle(color: ColorConstants.greyColor),
                          ),
                          controller: controllerAboutMe,
                          onChanged: (value) {
                            aboutMe = value;
                          },
                          focusNode: focusNodeAboutMe,
                        ),
                      ),
                      margin: const EdgeInsets.only(left: 30, right: 30),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),

                // Button
                Container(
                  child: TextButton(
                    onPressed: handleUpdateData,
                    child: const Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(ColorConstants.primaryColor),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.only(top: 50, bottom: 50),
                ),
              ],
            ),
            padding: const EdgeInsets.only(left: 15, right: 15),
          ),

          // Loading
          Positioned(
            child: isLoading ? const LoadingView() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
