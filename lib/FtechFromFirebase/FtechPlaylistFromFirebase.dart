import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rythm/providers/playlistProvider.dart';

Future<List<PlayListProvider>> ftechPlaylistFromFirebase() async {
  List<PlayListProvider> playlistArr = [];

  QuerySnapshot PlaylistSnapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("playlist")
      .get();
  PlaylistSnapshot.docs.forEach((doc) async {
    Map<String, dynamic> ListData = doc.data() as Map<String, dynamic>;

    PlayListProvider List = PlayListProvider(
      id: doc.id,
      name: ListData["name"],
      image: ListData["image"],
      desc: ListData["desc"],
    );
    List.setSongList((ListData["Songs"]));
    playlistArr.add(List);
  });
  return playlistArr;
}
