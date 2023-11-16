import 'package:flutter/material.dart';
import 'package:rythm/providers/songProvider.dart';

class GenreProvider extends ChangeNotifier {
  String genreName;
  int genreImage;
  List<SongProvider> songs;

  GenreProvider({
    this.genreName = "",
    this.genreImage = 0,
    this.songs = const [],
  });
}

List<GenreProvider> genreList = [
  GenreProvider(genreName: "Jazz", genreImage: 0xFFCE94BC, songs: []),
  GenreProvider(genreName: "Rock", genreImage: 0xFFDBBFDB, songs: []),
  GenreProvider(genreName: "Pop", genreImage: 0xFFB39DDB, songs: []),
  GenreProvider(genreName: "Reggae", genreImage: 0xFF9FA8DA, songs: []),
  GenreProvider(genreName: "Hip Hop", genreImage: 0xFF877BAE, songs: []),
  GenreProvider(genreName: "R&B", genreImage: 0xFFCE94BC, songs: []),
  GenreProvider(genreName: "Country", genreImage: 0xFFDBBFDB, songs: []),
  GenreProvider(genreName: "Classical", genreImage: 0xFF877BAE, songs: []),
  GenreProvider(genreName: "EDM", genreImage: 0xFFB6B5D8, songs: []),
  GenreProvider(genreName: "Metal", genreImage: 0xFFB39DDB, songs: []),
  GenreProvider(genreName: "Blues", genreImage: 0xFF877BAE, songs: []),
  GenreProvider(genreName: "JPOP", genreImage: 0xFFB59DFA, songs: []),
];
