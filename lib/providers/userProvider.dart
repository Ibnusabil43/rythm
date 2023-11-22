import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rythm/FtechFromFirebase/FtechPlaylistFromFirebase.dart';
import '../providers/playlistProvider.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class UsersProvider extends ChangeNotifier {
  String id;
  String email;
  String username;
  String password;
  String profileImage;
  List<PlayListProvider> playListArr = [];
  get getPlayListArr => playListArr;
  UsersProvider({
    this.id = "",
    this.email = "",
    this.username = "",
    this.password = "",
    this.profileImage = "",
  });

  void setid(String uid) {
    this.id = uid;
    print(id);
  }

  void fetchprofile() async {
    final docprofile = FirebaseFirestore.instance.collection('users');
    var doc = await docprofile.doc(id).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data()!;
      this.username = data['username'];
      this.email = data['email'];
      print(username);
      notifyListeners();
    }
  }

  void fetchPlaylist() async {
    playListArr = await ftechPlaylistFromFirebase();
    notifyListeners();
  }

  void tambahPlaylistBaru({
    required String namePlaylist,
    required String descPlaylist,
    required File? selectedImage,
    required String? selectedImageFileName,
  }) async {
    final uuid = Uuid();
    if (namePlaylist.isNotEmpty &&
        selectedImage != null &&
        selectedImageFileName != null) {
      // Mendapatkan direktori dokumen aplikasi
      final appDocDir = await getApplicationDocumentsDirectory();
      final imageFileName =
          selectedImageFileName; // Menggunakan nama file yang terpilih
      final localImage = File("${appDocDir.path}/$imageFileName");

      // Mengecek apakah file lokal ada
      if (await localImage.exists()) {
        final uniqueId = uuid.v4();
        // File lokal ada, Anda bisa menggunakan localImage untuk mengaksesnya
        // Tambahkan playlist baru dengan path gambar lokal
        playListArr.add(PlayListProvider(
          id: uniqueId.toString(), // Sesuaikan dengan kebutuhan
          name: namePlaylist, // Menggunakan value dari namePlaylist
          image: localImage.path,
          desc: descPlaylist, // Menggunakan value dari descPlaylist
        ));
        notifyListeners();
        // Bersihkan input setelah menambah playlist baru
        // Lakukan tindakan lain setelah berhasil menambahkan playlist
      } else {
        // File lokal tidak ditemukan, Anda perlu menanganinya sesuai kebutuhan Anda
        print('File lokal tidak ditemukan.');
      }
    }
  }

  void addLagu(
      {required PlayListProvider playlist, required SongProvider song}) async {
    var ref = FirebaseFirestore.instance.collection('songs').doc(song.id);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("playlist")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["name"] == playlist.name &&
              docSnapshot.data()["desc"] == playlist.desc &&
              docSnapshot.data()["image"] == playlist.image) {
            docSnapshot.reference.update({
              "Songs": FieldValue.arrayUnion([ref])
            });
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    notifyListeners();
  }

  void deletePlaylistoln({
    required PlayListProvider playlist,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("playlist")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["name"] == playlist.name &&
              docSnapshot.data()["desc"] == playlist.desc) {
            String imagePlaylist = docSnapshot.data()["imageName"];
            final desertRef = FirebaseStorage.instance
                .ref()
                .child('playlist/' + imagePlaylist);
            await desertRef.delete();
            await docSnapshot.reference.delete();
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    playListArr.remove(playlist);
    notifyListeners();
  }

  void deletePlaylist({required PlayListProvider playlist}) async {
    playListArr.remove(playlist);
    notifyListeners();
  }

  void tambahLagukePlaylist(
      {required PlayListProvider playlist, required SongProvider song}) {
    playlist.songList.add(song);
    notifyListeners();
  }

  void deleteLagudariPlaylist(
      {required PlayListProvider playlist, required SongProvider song}) {
    playlist.songList.remove(song);
    notifyListeners();
  }
}
