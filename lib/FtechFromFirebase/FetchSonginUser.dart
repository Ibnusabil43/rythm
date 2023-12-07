import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rythm/providers/songProvider.dart';

Future<List<SongProvider>> fetchSongUser() async {
  List<SongProvider> songList = [];
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('UserSongs')
      .get()
      .then((querySnapshot) async {
    for (var docSnapshot in querySnapshot.docs) {
      DocumentReference<Map<String, dynamic>> docRef =
          docSnapshot.data()['Songs'];
      var addSong = await docRef.get();
      SongProvider song = SongProvider(
        id: addSong.id,
        title: addSong['song_name'],
        artist: addSong['artist_name'],
        image: addSong['image_url'],
        song: addSong['song_url'],
        genre: addSong['song_genre'],
      );
      songList.add(song);
    }
  });
  return songList;
}
