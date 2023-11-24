import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rythm/FtechFromFirebase/FetchSonginPlaylistFromFirebase.dart';
import 'package:rythm/model/User.dart';
import 'package:rythm/providers/userProvider.dart';
import '../providers/playlistProvider.dart';
import 'package:rythm/providers/songProvider.dart';
import '../screen/listPlaylist.dart';
import '../screen/Play.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../screen/songListToAdd.dart';
import 'package:provider/provider.dart';
import '../screen/popupScreen.dart';

class playlist1 extends StatefulWidget {
  final PlayListProvider iniDaftarPlaylist;

  final int currIdx;
  const playlist1(
      {Key? key, required this.iniDaftarPlaylist, required this.currIdx})
      : super(key: key);

  @override
  State<playlist1> createState() => _playlist1State();
}

class _playlist1State extends State<playlist1> {
  List<SongProvider> songArr = [];
  @override
  void initState() {
    super.initState();
    _initializeSongs();
  }

  void _initializeSongs() async {
    try {
      widget.iniDaftarPlaylist.ftechSonginPlaylistFromFirebase();
      final collection = FirebaseFirestore.instance.collection('songs');
      print("tesssss");
      if (widget.iniDaftarPlaylist.tempSong.isEmpty) {
        songArr = [];
      } else {
        QuerySnapshot songsSnapshot = await collection
            .where(FieldPath.documentId,
                whereIn: widget.iniDaftarPlaylist.tempSong)
            .get();
        print("SongArr doc");
        var t = songsSnapshot.docs.toList();
        print(t);

        songArr = List.from(
            songsSnapshot.docs.map((doc) => SongProvider.fromSnapshot(doc)));
      }
      print("Songs fetched successfully:");
      // print(songArr);
      setState(() {});
    } catch (e) {
      print("Error fetching songs: $e");
    }
  }

  void addLagu(SongProvider song) {
    songArr.add(song);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C27),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFFD2AFFF),
                size: 33,
              ),
            ),
            Text(
              "Playlist",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color(0xFFD2AFFF),
              ),
            ),
            SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            child: Image.network(
                              widget.iniDaftarPlaylist.image,
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.iniDaftarPlaylist.name,
                            style: TextStyle(
                              color: Color(0xFFD2AFFF),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          Text(
                            widget.iniDaftarPlaylist.desc,
                            style: TextStyle(
                              color: Color(0xFFD2AFFF),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w100,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            if (widget.iniDaftarPlaylist.songList.length > 0) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Play(
                                    listSong: widget.iniDaftarPlaylist.songList,
                                    song: widget.iniDaftarPlaylist.songList[0],
                                    currIndex: 0);
                              }));
                            } else if (widget
                                    .iniDaftarPlaylist.songList.length ==
                                0) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return popUpWarning(
                                      errorMessage: "Playlist ini kosong",
                                      status: "error");
                                },
                              );
                            }
                          },
                          child: Icon(Icons.play_circle_fill_rounded,
                              color: Color(0xFFD2AFFF), size: 70)),
                    ],
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: songArr.length,
                  itemBuilder: ((context, index) {
                    if (index <= songArr.length) {
                      return songListinPlaylist(
                        iniDaftarPlaylist: context
                            .watch<UsersProvider>()
                            .playListArr[widget.currIdx],
                        currIdx: index,
                        listPlayList: context.watch<UsersProvider>(),
                      );
                    }
                  }),
                ),
              ),
            ]),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: Color(0xFFD2AFFF),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        songListToAdd(playlist: widget.iniDaftarPlaylist),
                  ),
                );
              },
              child: Icon(
                Icons.add_rounded,
                size: 50,
                color: Color(0xFF1C1C27),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSong() {
    return Container(
      width: double.infinity,
      height: 61,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xffd2afff),
      ),
      padding: EdgeInsets.symmetric(horizontal: 29.5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_rounded,
            size: 41,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text("Add Song",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white))
        ],
      ),
    );
  }
}

class songListinPlaylist extends StatelessWidget {
  final PlayListProvider iniDaftarPlaylist;
  final UsersProvider listPlayList;
  final int currIdx;
  const songListinPlaylist(
      {Key? key,
      required this.iniDaftarPlaylist,
      required this.currIdx,
      required this.listPlayList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Play(
                      listSong: iniDaftarPlaylist.songList,
                      song: iniDaftarPlaylist.songList[currIdx],
                      currIndex: currIdx,
                    );
                  }));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Image.network(
                          iniDaftarPlaylist.songList[currIdx].image,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      SizedBox(
                        width: 11.81,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            iniDaftarPlaylist.songList[currIdx].title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD2AFFF),
                            ),
                          ),
                          Text(
                            iniDaftarPlaylist.songList[currIdx].artist,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFD2AFFF),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.only(top: 24, left: 31, right: 31),
                        height: 80,
                        decoration: ShapeDecoration(
                          color: Color(0xFFD2AFFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  context
                                      .read<UsersProvider>()
                                      .deleteLagudariPlaylist(
                                          playlist: iniDaftarPlaylist,
                                          song: iniDaftarPlaylist
                                              .songList[currIdx]);
                                  Navigator.pop(context);
                                  // Tutup modal bottom sheet
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Hapus Lagu',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.more_vert_rounded,
                    color: Color(0xFFD2AFFF), size: 30),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
