// ignore_for_file: body_might_complete_normally_nullable

import 'package:rythm/screen/Playlist/addPlaylist.dart';
import 'package:rythm/screen/Playlist//playlist1.dart';
import 'package:rythm/screen/Playlist//searchPlaylist.dart';
import 'package:flutter/material.dart';
import 'package:rythm/providers/playlistProvider.dart';
import 'package:provider/provider.dart';
import 'package:rythm/providers/userProvider.dart';

class listPlaylist extends StatefulWidget {
  const listPlaylist({super.key});

  @override
  State<listPlaylist> createState() => _listPlaylistState();
}

class _listPlaylistState extends State<listPlaylist> {
  @override
  void initState() {
    super.initState();
    context.read<UsersProvider>().fetchPlaylist();
    print("Playlist Arr");
    print(context.read<UsersProvider>().getPlayListArr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Playlist Anda",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color(0xFFD2AFFF),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPlaylist()),
                );
              },
              child: Icon(
                Icons.search_rounded,
                color: Color(0xFFD2AFFF),
                size: 33,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF1C1C27),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        context.watch<UsersProvider>().playListArr.length,
                    itemBuilder: (context, index) {
                      if (index <=
                          context.watch<UsersProvider>().playListArr.length) {
                        return daftarPlaylist(
                            iniDaftarPlaylist: context
                                .watch<UsersProvider>()
                                .playListArr[index],
                            listPlayList: context.watch<UsersProvider>(),
                            currIdx: index);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: Color(0xFFD2AFFF),
              onPressed: () async {
                String status = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addPlaylist(),
                  ),
                );
                if (status == "addPlaylist") {
                  context.read<UsersProvider>().fetchPlaylist();
                }
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
}

class daftarPlaylist extends StatefulWidget {
  final PlayListProvider iniDaftarPlaylist;
  final UsersProvider listPlayList;
  final int currIdx;

  const daftarPlaylist(
      {Key? key,
      required this.iniDaftarPlaylist,
      required this.listPlayList,
      required this.currIdx})
      : super(key: key);

  @override
  _DaftarPlaylistState createState() => _DaftarPlaylistState();
}

class _DaftarPlaylistState extends State<daftarPlaylist> {
  bool isBottomSheetVisible = false; // Example mutable state

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return playlist1(
                iniDaftarPlaylist:
                    context.watch<UsersProvider>().playListArr[widget.currIdx],
                currIdx: widget.currIdx,
              );
            }));
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      child: Image.network(
                        widget.iniDaftarPlaylist.image,
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    SizedBox(
                      width: 19,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.iniDaftarPlaylist.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD2AFFF),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.iniDaftarPlaylist.desc,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFD2AFFF),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Container(
                              padding:
                                  EdgeInsets.only(top: 24, left: 31, right: 31),
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
                                            .deletePlaylistoln(
                                                playlist:
                                                    widget.iniDaftarPlaylist);
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
                                            'Hapus Playlist',
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
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12,
        )
      ],
    );
  }
}
