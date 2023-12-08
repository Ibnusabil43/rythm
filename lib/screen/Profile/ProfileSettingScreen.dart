// ignore_for_file: body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rythm/FtechFromFirebase/FetchSonginUser.dart';
import 'package:rythm/providers/userProvider.dart';
import 'package:rythm/screen/welcome.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:rythm/Screen/Play.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:rythm/PopUpWindow/PopUpConfirmationMessage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  List<SongProvider> uploadedSong = [];
  bool _isEditing = false;
  String _username = "";
  TextEditingController _usernameController = TextEditingController();
  void initState() {
    super.initState();
    _loadUsername(); // Set nilai awal TextField
    super.initState();
    context.read<UsersProvider>().uploadedSongs = [];
    context.read<UsersProvider>().fetchSong();
    context.read<UsersProvider>().fetchImage();

    print("Songfetchuploaded");
  }

  void _loadUsername() {
    setState(() {
      _username = context.read<UsersProvider>().username;
      _usernameController.text = _username;
    });
  }

  File? selectedImage;
  String?
      selectedImageFileName; // Tambahkan variabel untuk nama file gambar terpilih

  Future<void> uploadImageToFirebase() async {
    if (selectedImage != null) {
      try {
        final storage = FirebaseStorage.instance;
        final user = FirebaseAuth.instance.currentUser!;
        final userDoc =
            FirebaseFirestore.instance.collection("users").doc(user.uid);

        // Fetch the current profile image URL
        final currentProfileImageUrl =
            (await userDoc.get()).data()?["profileImageUrl"] as String?;

        // Delete the previous profile image if it exists
        if (currentProfileImageUrl != null) {
          try {
            await storage.refFromURL(currentProfileImageUrl).delete();
          } catch (deleteError) {
            // Handle the case where the object is not found or deletion fails
            print("Error deleting previous profile image: $deleteError");
          }
        }

        // Upload the new profile image
        final reference =
            storage.ref().child("profile_images/${user.uid}_${DateTime.now()}");
        await reference.putFile(
            selectedImage!, SettableMetadata(contentType: "image/jpeg"));
        final imageUrl = await reference.getDownloadURL();

        // Update the user's profile in Firebase Firestore with the new image URL
        await userDoc.update({"profileImageUrl": imageUrl});

        print("Image uploaded successfully!");
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imageFileName = pickedFile.name;
      final imageFile = File(pickedFile.path);
      final localImage = File('${appDocDir.path}/$imageFileName');
      try {
        await imageFile.copy(localImage.path);
        setState(() {
          selectedImage = localImage;
          selectedImageFileName = imageFileName;
        });
        await uploadImageToFirebase();
      } catch (e) {
        print('Error copying file: $e');
      }
    }
  }

  Widget _buildProfileImage(BuildContext context) {
    final profileImageUrl = context.watch<UsersProvider>().profileImageUrl;
    return profileImageUrl != null
        ? Image.network(
            profileImageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
        : Icon(Icons.person_rounded, size: 200, color: Color(0xFFD2AFFF));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C27),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 28,
            ),
            Text(
              "Profile",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color(0xFFD2AFFF),
              ),
            ),
            InkWell(
              onTap: () {
                // Menampilkan popup konfirmasi
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationPopup(
                      confirmationMessage: 'Apakah Anda Yakin Ingin Logout?',
                      onConfirm: () {
                        context.read<UsersProvider>().playListArr = [];
                        // Tindakan yang akan diambil jika tombol Confirm ditekan
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => welcome()));
                      },
                      onCancel: () {
                        // Tindakan yang akan diambil jika tombol Cancel ditekan
                        Navigator.pop(context); // Menutup popup
                      },
                    );
                  },
                );
              },
              child: Icon(
                Icons.logout_rounded,
                color: Color(0xFFD2AFFF),
                size: 27,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () async {
                        await getImage();
                      },
                      child: selectedImage != null ||
                              context
                                  .watch<UsersProvider>()
                                  .profileImageUrl
                                  .isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: selectedImage != null
                                  ? Image.file(
                                      selectedImage!,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : _buildProfileImage(context),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Icon(Icons.person_rounded,
                                  size: 200, color: Color(0xFFD2AFFF)),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFD2AFFF),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_2_rounded,
                            size: 30,
                            color: Color(0xFFD2AFFF),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Username",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFD2AFFF).withOpacity(0.6),
                                ),
                              ),
                              _isEditing
                                  ? Row(
                                      children: [
                                        Container(
                                          width: 200,
                                          child: TextField(
                                            controller: _usernameController,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200,
                                              color: Color(0xFFD2AFFF),
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFD2AFFF)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFD2AFFF)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      _username,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200,
                                        color: Color(0xFFD2AFFF),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isEditing = !_isEditing;
                          if (!_isEditing) {
                            if (_usernameController.text != _username) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationPopup(
                                    confirmationMessage:
                                        'Apakah Anda Yakin Ingin Merubah Username Anda Menjadi ${_usernameController.text}?',
                                    onConfirm: () {
                                      // Tindakan yang akan diambil jika tombol Confirm ditekan
                                      setState(() {
                                        _username = _usernameController.text;
                                        //ISI ALGORITMA UPDATE FIREBASE DISINI
                                        CollectionReference collRef =
                                            FirebaseFirestore.instance
                                                .collection("users");
                                        collRef
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          "username": _usernameController.text
                                        });
                                      });
                                      //ISI ALGORITMA UPDATE FIREBASE DISINI KALO GA DIATAS
                                      Navigator.pop(context);
                                    },
                                    onCancel: () {
                                      // Tindakan yang akan diambil jika tombol Cancel ditekan
                                      _usernameController.text = _username;
                                      Navigator.pop(context); // Menutup popup
                                    },
                                  );
                                },
                              );
                            }
                            //Update Username Firebase
                          }
                        });
                      },
                      child: Icon(
                        _isEditing ? Icons.check_rounded : Icons.edit_rounded,
                        size: 20,
                        color: Color(0xFFD2AFFF),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_rounded,
                            size: 30,
                            color: Color(0xFFD2AFFF),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFD2AFFF).withOpacity(0.6),
                                ),
                              ),
                              Text(
                                context.watch<UsersProvider>().email,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200,
                                  color: Color(0xFFD2AFFF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Your Song",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFD2AFFF),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<UsersProvider>().uploadedSongs.length,
                itemBuilder: (context, index) {
                  if (index <
                      context.watch<UsersProvider>().uploadedSongs.length) {
                    return YourSong(
                      iniListLagu:
                          context.watch<UsersProvider>().uploadedSongs[index],
                      currIdx: index,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YourSong extends StatelessWidget {
  final SongProvider iniListLagu;
  final int currIdx;

  const YourSong({Key? key, required this.iniListLagu, required this.currIdx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Play(
                        listSong: context.watch<UsersProvider>().uploadedSongs,
                        song: context
                            .watch<UsersProvider>()
                            .uploadedSongs[currIdx],
                        currIndex: currIdx);
                  }));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Image.network(
                          iniListLagu.image,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      SizedBox(
                        width: 11.81,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            iniListLagu.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD2AFFF),
                            ),
                          ),
                          Text(
                            iniListLagu.artist,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFD2AFFF),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.only(top: 24, left: 31, right: 31),
                        height: 80,
                        decoration: ShapeDecoration(
                          color: Color(0xFFD2AFFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  //PANGGIL DELETE SONG DISINI
                                  context.read<UsersProvider>().deleteSongUser(
                                      user: context.read<UsersProvider>(),
                                      song: iniListLagu);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Hapus Lagu',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.more_vert_rounded,
                    color: Color(0xFFD2AFFF), size: 30),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
