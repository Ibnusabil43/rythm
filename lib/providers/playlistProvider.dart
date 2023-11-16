import 'package:flutter/material.dart';
import 'package:rythm/providers/songProvider.dart';

class PlayListProvider extends ChangeNotifier {
  String id;
  String name;
  String image;
  String desc;
  List<SongProvider> songList = [];

  PlayListProvider({
    this.id = "",
    this.name = "",
    this.image = "",
    this.desc = "",
  });
}
