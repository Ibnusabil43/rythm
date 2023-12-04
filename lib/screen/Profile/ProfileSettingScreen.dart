// ignore_for_file: body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rythm/providers/userProvider.dart';
import 'package:rythm/screen/welcome.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:rythm/Screen/Play.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:rythm/PopUpWindow/PopUpConfirmationMessage.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  bool _isEditing = false;
  String _username = "Yanto";
  TextEditingController _usernameController = TextEditingController();
  void initState() {
    List<UsersProvider> uploadedSong = [];
    super.initState();
    _usernameController.text = _username; // Set nilai awal TextField
    super.initState();
    context.read<UsersProvider>().fetchSongUser();
  }

  void _initState() {
    final user = context.read<UsersProvider>();
    user.fetchSongUser();
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
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "assets/ProfilePicture.png",
                          width: 200,
                          height: 200,
                        ),
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
                                "admin@gmail.com",
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
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<UsersProvider>().uploadedSong.length,
                itemBuilder: (context, index) {
                  if (index <
                      context.watch<UsersProvider>().uploadedSong.length) {
                    return YourSong(
                      iniListLagu:
                          context.watch<UsersProvider>().uploadedSong[index],
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
                        listSong: context.watch<UsersProvider>().uploadedSong,
                        song: context
                            .watch<UsersProvider>()
                            .uploadedSong[currIdx],
                        currIndex: currIdx);
                  }));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Image.file(
                          File(iniListLagu.image),
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
