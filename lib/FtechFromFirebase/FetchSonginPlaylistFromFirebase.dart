// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:rythm/providers/playlistProvider.dart';
// import 'package:rythm/providers/songProvider.dart';

// Future<void> ftechSonginPlaylistFromFirebase(
//     PlayListProvider NamaPlayList) async {
//   List<SongProvider> songArr = [];
//   final collection = FirebaseFirestore.instance.collection('songs');

//   QuerySnapshot songsSnapshot = await collection
//       .where(FieldPath.documentId, whereIn: NamaPlayList.songList)
//       .get();
//   print("SongArr doc");
//   print(songsSnapshot.docs);
//   songsSnapshot.docs.forEach((doc) {
//     Map<String, dynamic> songData = doc.data() as Map<String, dynamic>;

//     SongProvider song = SongProvider(
//       id: doc.id,
//       title: songData['song_name'],
//       artist: songData['artist_name'],
//       image: songData['image_url'],
//       song: songData['song_url'],
//       genre: songData['song_genre'],
//     );
//     songArr.add(song);
//   });
//   print("SongArr playlist");
//   print(songArr);
//   NamaPlayList.setSongList(songArr);
// }
