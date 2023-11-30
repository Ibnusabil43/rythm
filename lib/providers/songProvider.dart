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

  SongProvider.fromSnapshot(snapshot)
      : id = snapshot.id,
        title = snapshot['song_name'],
        artist = snapshot['artist_name'],
        image = snapshot['image_url'],
        song = snapshot['song_url'],
        genre = snapshot['song_genre'];

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
}

List<SongProvider> songGen = [];
List<SongProvider> songArr = [];
