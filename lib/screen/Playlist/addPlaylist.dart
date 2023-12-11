import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rythm/FtechFromFirebase/FtechPlaylistFromFirebase.dart';
import 'package:rythm/PopUpWindow/popupScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class addPlaylist extends StatefulWidget {
  const addPlaylist({super.key});

  @override
  State<addPlaylist> createState() => _addPlaylistState();
}

class _addPlaylistState extends State<addPlaylist> {
  final namePlaylist = TextEditingController();
  final descPlaylist = TextEditingController();
  final storageRef = FirebaseStorage.instance.ref();
  var imageUrl;
  File? selectedImage;
  String?
      selectedImageFileName; // Tambahkan variabel untuk nama file gambar terpilih

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
      } catch (e) {
        print('Error copying file: $e');
      }
    }
  }

  void _showLoading() {
    EasyLoading.show();
  }

  void _dismissLoading() {
    EasyLoading.dismiss();
  }

  Future<void> UpImage() async {
    String fileImagepath = selectedImage!.path;
    String target = fileImagepath.substring(fileImagepath.lastIndexOf('/') + 1);
    final uuid = Uuid();
    final uniqueId = uuid.v4();
    target = uniqueId.toString() + target;
    final imageref = FirebaseStorage.instance.ref().child('playlist/$target');
    File file = File(fileImagepath);
    try {
      await imageref.putFile(
          file,
          SettableMetadata(
            contentType: 'image/jpeg',
          ));
      imageUrl = await imageref.getDownloadURL();
      print("URL IMAGE");
      print(imageUrl);
      CollectionReference playlist = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("playlist");
      playlist.add({
        'name': namePlaylist.text,
        'desc': descPlaylist.text,
        'image': imageUrl.toString(),
        'imageName': target,
        'Songs': [],
      });
    } catch (e) {
      print('Error copying file: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1C1C27),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context, " ");
                },
                child: Icon(Icons.arrow_back_rounded,
                    color: Color(0xFFD2AFFF), size: 33),
              ),
              Text(
                'Buat Playlist',
                style: TextStyle(
                  color: Color(0xFFD2AFFF),
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 33,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Nama Playlist',
                  style: TextStyle(
                    color: Color(0xFFD2AFFF),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                formNamaPlaylist(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Deskripsi Playlist',
                  style: TextStyle(
                    color: Color(0xFFD2AFFF),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                formDescPlaylist(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Cover Playlist',
                  style: TextStyle(
                    color: Color(0xFFD2AFFF),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () async {
                    await getImage();
                  },
                  child: selectedImage != null
                      ? Container(
                          width: double.infinity,
                          height:
                              337, // Tinggi diatur ke 0 agar tidak ada ruang tambahan
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      : Container(
                          width: double.infinity,
                          height: 337,
                          padding: EdgeInsets.only(
                              top: 71, bottom: 93, left: 96, right: 96),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFFD2AFFF)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.upload_rounded,
                                  color: Color(0xFFD2AFFF), size: 105),
                              Container(
                                  width: 160,
                                  height: 49,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFFD2AFFF),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Upload Foto',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        _showLoading();
                        if (namePlaylist.text.isEmpty ||
                            descPlaylist.text.isEmpty ||
                            selectedImage == null) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return popUpWarning(
                                errorMessage: "Harap Lengkapi Form Playlist!",
                                status: "error",
                              );
                            },
                          );
                        } else {
                          await UpImage();
                          // context.read<UsersProvider>().tambahPlaylistBaru(
                          //       namePlaylist: namePlaylist.text,
                          //       descPlaylist: descPlaylist.text,
                          //       selectedImage: selectedImage,
                          //       selectedImageFileName: selectedImageFileName,
                          //     );

                          Navigator.pop(context, "addPlaylist");
                          ftechPlaylistFromFirebase();
                          _dismissLoading();
                        }
                      },
                      child: Container(
                          width: 160,
                          height: 49,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFD2AFFF),
                          ),
                          child: Center(
                            child: Text(
                              'Buat Playlist',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget formNamaPlaylist() {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF313142),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            hintText: 'Masukkan Nama Playlist',
            hintStyle: TextStyle(
              color: Color(0xFFD2AFFF).withOpacity(0.5),
            ),
            border: InputBorder.none),
        onChanged: (value) {
          setState(() {
            namePlaylist.text = value;
          });
        },
      ),
    );
  }

  Widget formDescPlaylist() {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF313142),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            hintText: 'Masukkan Deskripsi Playlist',
            hintStyle: TextStyle(
              color: Color(0xFFD2AFFF).withOpacity(0.5),
            ),
            border: InputBorder.none),
        onChanged: (value) {
          setState(() {
            descPlaylist.text = value;
          });
        },
      ),
    );
  }
}
