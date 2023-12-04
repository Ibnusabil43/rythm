// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rythm/providers/songProvider.dart';

// Future<List<SongProvider>> ftechSongsFromUser() async {
//   List<SongProvider> songArr = [];

//   QuerySnapshot songsSnapshot =
//       await FirebaseFirestore.instance.collection('songs').get();
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
//   return songArr;
// }