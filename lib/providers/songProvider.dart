import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:flutter/material.dart';

class SongProvider extends ChangeNotifier {
  String id;
  String title;
  String artist;
  String image;
  String song;
  String genre;

  SongProvider(
      {this.id = "",
      this.title = "",
      this.artist = "",
      this.image = "",
      this.song = "",
      this.genre = ""});

  factory SongProvider.fromMap(Map<String, dynamic> map) {
    return SongProvider(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      image: map['image'],
      song: map['song'],
      genre: map['genre'],
    );
  }

  List<SongProvider> songArray = [];

  // void tambahSongBaru({
  //   required String title,
  //   required String artist,
  //   required File? selectedImage,
  //   required String? selectedImageFileName,
  //   required File? selectedAudioFile,
  //   required String? selectedAudioFileName,
  //   required String genre,
  // }) async {
  //   final uuid = Uuid();

  //   if (title.isNotEmpty &&
  //       artist.isNotEmpty &&
  //       selectedImage != null &&
  //       selectedImageFileName != null &&
  //       selectedAudioFile != null &&
  //       selectedAudioFileName != null) {
  //     // Mendapatkan direktori dokumen aplikasi
  //     final appDocDir = await getApplicationDocumentsDirectory();

  //     // Menggunakan nama file yang terpilih
  //     final imageFileName = selectedImageFileName;
  //     final audioFileName = selectedAudioFileName;

  //     // File lokal untuk gambar dan lagu
  //     final localImage = File("${appDocDir.path}/$imageFileName");
  //     final localAudio = File("${appDocDir.path}/$audioFileName");

  //     // Mengecek apakah file lokal ada
  //     if (await localImage.exists() && await localAudio.exists()) {
  //       final uniqueId = uuid.v4();

  //       // File lokal ada, Anda bisa menggunakan localImage dan localAudio untuk mengaksesnya
  //       // Tambahkan lagu baru dengan path gambar dan lagu lokal
  //       songArray.add(SongProvider(
  //         id: uniqueId.toString(), // Sesuaikan dengan kebutuhan
  //         title: title,
  //         artist: artist,
  //         image: localImage.path,
  //         song: localAudio.path,
  //         genre: genre,
  //       ));
  //       notifyListeners();
  //       // Bersihkan input setelah menambah lagu baru
  //       // Lakukan tindakan lain setelah berhasil menambahkan lagu
  //     } else {
  //       // File lokal tidak ditemukan, Anda perlu menanganinya sesuai kebutuhan Anda
  //       print('File lokal tidak ditemukan.');
  //     }
  //   }
  // }
}

List<SongProvider> songArr = [];
