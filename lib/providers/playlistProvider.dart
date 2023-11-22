import 'package:cloud_firestore/cloud_firestore.dart';
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
}
