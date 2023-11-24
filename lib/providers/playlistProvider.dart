import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rythm/providers/songProvider.dart';

class PlayListProvider extends ChangeNotifier {
  String id;
  String name;
  String image;
  String desc;
  List<dynamic> tempSong = [];
  List<SongProvider> songList = [];

  PlayListProvider({
    this.id = "",
    this.name = "",
    this.image = "",
    this.desc = "",
  });

  void addSong(SongProvider song) {
    songList.add(song);
    notifyListeners();
  }

  void setSongList(List<dynamic> songList) {
    this.tempSong = songList;
    notifyListeners();
  }

  void ftechSonginPlaylistFromFirebase() async {
    // List<SongProvider> songArr = [];
    final collection = FirebaseFirestore.instance.collection('songs');
    print("tesssss");
    if (this.tempSong.isEmpty) {
      this.songList = [];
      notifyListeners();
    } else {
      QuerySnapshot songsSnapshot = await collection
          .where(FieldPath.documentId, whereIn: this.tempSong)
          .get();
      print("SongArr doc");
      var t = songsSnapshot.docs.toList();
      print(t);

      this.songList = List.from(
          songsSnapshot.docs.map((doc) => SongProvider.fromSnapshot(doc)));

      notifyListeners();
    }
  }

  void fetchplaylistid(String id) async {
    var ref = FirebaseFirestore.instance.collection('songs');
    var ref2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("playlist")
        .doc(id)
        .get();

    if (ref2.exists) {
      Map<String, dynamic> ListData = ref2.data() as Map<String, dynamic>;
      this.id = id;
      this.name = ListData["name"];
      this.image = ListData["image"];
      this.desc = ListData["desc"];
      this.tempSong = ListData["Songs"];
      if (this.tempSong.isEmpty) {
        this.songList = [];
        notifyListeners();
      } else {
        QuerySnapshot songsSnapshot =
            await ref.where(FieldPath.documentId, whereIn: this.tempSong).get();
        print("SongArr doc");
        var t = songsSnapshot.docs.toList();
        print(t);

        this.songList = List.from(
            songsSnapshot.docs.map((doc) => SongProvider.fromSnapshot(doc)));
        print("songlist$songList");
        notifyListeners();
      }
    }
  }
}
