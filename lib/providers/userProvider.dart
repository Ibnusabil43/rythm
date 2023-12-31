import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rythm/FtechFromFirebase/FetchSonginUser.dart';
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
  String profileImageUrl;
  List<PlayListProvider> playListArr = [];
  List<SongProvider> uploadedSongs = [];
  List<dynamic> tempSong = [];

  get getPlayListArr => playListArr;
  UsersProvider({
    this.id = "",
    this.email = "",
    this.username = "",
    this.password = "",
    this.profileImageUrl = "",
  });

  void setid(String uid) {
    this.id = uid;
    print(id);
  }

  Future<void> fetchImage() async {
    final docprofile = FirebaseFirestore.instance.collection('users');
    var doc = await docprofile.doc(id).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data()!;
      this.profileImageUrl = data['profileImageUrl'];
      notifyListeners();
    }
  }

  Future<void> fetchSong() async {
    List<SongProvider> uploadedSong = await fetchSongUser();
    for (var i = 0; i < uploadedSong.length; i++) {
      uploadedSongs.add(SongProvider(
        id: uploadedSong[i].id,
        title: uploadedSong[i].title,
        artist: uploadedSong[i].artist,
        image: uploadedSong[i].image,
        song: uploadedSong[i].song,
        genre: uploadedSong[i].genre,
      ));
    }
    notifyListeners();
  }

  Future<void> deleteSongUser(
      {required UsersProvider user, required SongProvider song}) async {
    var deletedSongCollection =
        await FirebaseFirestore.instance.collection("songs");

    var deletedArtistSongCollection = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("UserSongs");

    deletedSongCollection.doc(song.id).get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;

      await FirebaseStorage.instance
          .ref()
          .child("songs/" + data["SongStorage"])
          .delete();
      await FirebaseStorage.instance
          .ref()
          .child("images/" + data["ImageStorage"])
          .delete();
      // delete Songs Collection
      await deletedSongCollection.doc(song.id).delete();
      // delete ArtistSong Collection
      deletedArtistSongCollection
          .where("Songs", isEqualTo: deletedSongCollection.doc(song.id))
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await deletedArtistSongCollection.doc(docSnapshot.id).delete();
        }
      });
    });
    user.uploadedSongs.remove(song);
    notifyListeners();
  }

  void setSongList(List<dynamic> songList) {
    this.tempSong = songList;
    notifyListeners();
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

  // void addLagu(
  //     {required PlayListProvider playlist, required SongProvider song}) async {
  //   var ref = FirebaseFirestore.instance.collection('songs').doc(song.id);
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("playlist")
  //       .get()
  //       .then(
  //     (querySnapshot) async {
  //       for (var docSnapshot in querySnapshot.docs) {
  //         if (docSnapshot.data()["name"] == playlist.name &&
  //             docSnapshot.data()["desc"] == playlist.desc &&
  //             docSnapshot.data()["image"] == playlist.image) {
  //           docSnapshot.reference.update({
  //             "Songs": FieldValue.arrayUnion([ref])
  //           });
  //           playlist.songList.add(song);
  //         }
  //       }
  //     },
  //     onError: (e) => print("Error completing: $e"),
  //   );
  //   notifyListeners();
  // }

  void addLagu2({required String playlist, required SongProvider song}) async {
    var ref = FirebaseFirestore.instance.collection('songs').doc(song.id);
    var ref2 = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("playlist")
        .doc(playlist);

    print("ref$ref");
    print("ref2$ref2");
    await ref2.update({
      "Songs": FieldValue.arrayUnion([ref])
    });
  }

  void deleteLagu2(
      {required PlayListProvider playlist, required SongProvider song}) async {
    playlist.songList.remove(song);
    var ref = FirebaseFirestore.instance.collection('songs').doc(song.id);
    var ref2 = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("playlist")
        .doc(playlist.id);

    print("ref$ref");
    print("ref2$ref2");
    await ref2.update({
      "Songs": FieldValue.arrayRemove([ref])
    });
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
