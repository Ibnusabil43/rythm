import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rythm/providers/GenreProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../screen/popupScreen.dart';
import '../providers/songProvider.dart';

class UploadSong extends StatefulWidget {
  const UploadSong({super.key});

  @override
  State<UploadSong> createState() => _UploadSongState();
}

class _UploadSongState extends State<UploadSong> {
  String selectedGenre = 'Pilih Genre';
  final genreName = TextEditingController();
  final songName = TextEditingController();
  final artistName = TextEditingController();
  final firestoreinstance = FirebaseFirestore.instance;
  File? selectedImage;
  String? selectedImageFileName;
  File? selectedAudioFile;
  String? selectedAudioFileName;
  final storageRef = FirebaseStorage.instance.ref();
  var imageUrl, songUrl;
  // DatabaseReference ref = FirebaseDatabase.instance.ref("songs");
  // final imageref = FirebaseStorage.instance.ref().child('imagesSong.jpg');
  // final songref = FirebaseStorage.instance.ref().child('songs');

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final imageFileName = pickedFile.name;
      final imageFile = File(pickedFile.path);
      final localImage = File('${appDocDir.path}/$imageFileName');
      String filepath = imageFile.path;
      String target = filepath.substring(filepath.lastIndexOf('/') + 1);
      final imageref = FirebaseStorage.instance.ref().child('images/$target');
      File file = File(filepath);
      try {
        await imageFile.copy(localImage.path);
        await imageref.putFile(
            file,
            SettableMetadata(
              contentType: 'image/jpeg',
            ));
        imageUrl = await imageref.getDownloadURL();
        setState(() {
          selectedImage = localImage;
          selectedImageFileName = imageFileName;
        });
      } catch (e) {
        print('Error copying file: $e');
      }
    }
  }

  Future<void> getAudioFile() async {
    try {
      // Membuka dialog untuk memilih file audio
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final audioFile = File(result.files.single.path!);
        final audioFileName = result.files.single.name!;
        final localAudioFile = File('${appDocDir.path}/$audioFileName');
        String filepath = audioFile.path;
        String target = filepath.substring(filepath.lastIndexOf('/') + 1);
        final songref = FirebaseStorage.instance.ref().child('songs/$target');
        await audioFile.copy(localAudioFile.path);
        await songref.putFile(
            audioFile,
            SettableMetadata(
              contentType: 'audio/mpeg',
            ));
        songUrl = await songref.getDownloadURL();

        setState(() {
          selectedAudioFile = localAudioFile;
          selectedAudioFileName = audioFileName;
        });
      }
    } catch (e) {
      print('Error selecting audio file: $e');
    }
  }

  Finalupload() {
    var data = {
      "song_name": songName.text,
      "artist_name": artistName.text,
      "song_genre": genreName.text,
      "image_url": imageUrl.toString(),
      "song_url": songUrl.toString(),
    };
    firestoreinstance.collection("tes").doc().set(data).then((value) {
      print("berhasil");
    }).catchError((error) {
      print(error);
    });
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Upload Lagu",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color(0xFFD2AFFF),
              ),
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
              Text(
                'Judul Lagu',
                style: TextStyle(
                  color: Color(0xFFD2AFFF),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              formJudulLagu(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Nama Artist',
                style: TextStyle(
                  color: Color(0xFFD2AFFF),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              formNamaArtist(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Genre Lagu',
                style: TextStyle(
                  color: Color(0xFFD2AFFF),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              genreDropDown(),
              SizedBox(
                height: 20,
              ),
              Text(
                'File Lagu',
                style: TextStyle(
                  color: Color(0xFFD2AFFF),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              songFile(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Cover Lagu',
                style: TextStyle(
                  color: Color(0xFFD2AFFF),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
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
                            side:
                                BorderSide(width: 1, color: Color(0xFFD2AFFF)),
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
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      if (songName.text.isEmpty ||
                          genreName.text.isEmpty ||
                          artistName.text.isEmpty ||
                          selectedGenre == 'Pilih Genre' ||
                          selectedAudioFile == null ||
                          selectedImage == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return popUpWarning(
                                errorMessage:
                                    "Harap Lengkapi Form Upload Lagu !",
                                status: "error");
                          },
                        );
                      } else {
                        CollectionReference collRef =
                            FirebaseFirestore.instance.collection("songs");
                        collRef.add({
                          "song_name": songName.text,
                          "artist_name": artistName.text,
                          "song_genre": genreName.text,
                          "image_url": imageUrl.toString(),
                          "song_url": songUrl.toString(),
                        });
                        showDialog(
                          context: context,
                          builder: (context) {
                            return popUpWarning(
                                errorMessage: "Upload Lagu Berhasil !",
                                status: "success");
                          },
                        );
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFFD2AFFF),
                      ),
                      child: Center(
                        child: Text(
                          'Upload Lagu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget formJudulLagu() {
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
            hintText: 'Masukkan Judul Lagu',
            hintStyle: TextStyle(
              color: Color(0xFFD2AFFF).withOpacity(0.5),
            ),
            border: InputBorder.none),
        onChanged: (value) {
          setState(() {
            songName.text = value;
          });
        },
      ),
    );
  }

  Widget formNamaArtist() {
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
            hintText: 'Masukkan Nama Artist',
            hintStyle: TextStyle(
              color: Color(0xFFD2AFFF).withOpacity(0.5),
            ),
            border: InputBorder.none),
        onChanged: (value) {
          setState(() {
            artistName.text = value;
          });
        },
      ),
    );
  }

  Widget genreDropDown() {
    List<String> genreOptions = [
      'Pilih Genre', // Tambahkan hint text sebagai item pertama
    ];

    for (int i = 0; i < genreList.length; i++) {
      genreOptions.add(genreList[i].genreName);
    }

    // Nilai default

    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF313142),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: DropdownButtonFormField<String>(
        value: selectedGenre,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedGenre = newValue;
              genreName.text = selectedGenre;
            });
          }
        },
        items: genreOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontFamily: 'Poppins',
              ),
            ),
          );
        }).toList(),
        style: TextStyle(
          color: Color(0xFFD2AFFF),
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          hintText: 'Pilih Genre',
          hintStyle: TextStyle(
            color: Color(0xFFD2AFFF).withOpacity(0.5),
            fontFamily: 'Poppins',
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget songFile() {
    return InkWell(
      onTap: () async {
        await getAudioFile();
      },
      child: Container(
        height: 51,
        width: double.infinity,
        decoration: ShapeDecoration(
          color: Color(0xFF313142),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedAudioFileName ?? 'Belum ada file yang dipilih',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontFamily: 'Poppins',
              ),
            ),
            Icon(
              Icons.upload_rounded,
              color: Color(0xFFD2AFFF),
            ),
          ],
        ),
      ),
    );
  }
}
