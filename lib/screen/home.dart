import 'package:rythm/providers/songProvider.dart';
import '../screen/Play.dart';
import '../screen/listPlaylist.dart';
import '../screen/searchLagu.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
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
            Text(
              'Selamat Malam',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchLagu()),
                );
              },
              child: Icon(
                Icons.search_rounded,
                color: Color(0xFFD2AFFF),
                size: 27,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Rilis Baru !',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 11,
            ),
            _buildRilisBaru(),
            SizedBox(
              height: 31,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => listPlaylist()),
                );
              },
              child: _buildTampilkanPlaylist(),
            ),
            SizedBox(
              height: 21,
            ),
            Text(
              "Terakhir Diputar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD2AFFF),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songArr.length,
                itemBuilder: (context, index) {
                  if (index < songArr.length) {
                    return lastPlayed(
                      iniListLagu: songArr[index],
                      currIdx: index,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRilisBaru() {
    return Container(
      padding: EdgeInsets.only(right: 14),
      width: double.infinity,
      height: 115,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Color(0xffd2afff)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Image.asset("assets/home/rilisBaru.png"),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 29,
                    ),
                    Text("Idol",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    Text(
                      "YOASOBI",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.play_circle_fill_outlined,
            color: Colors.white,
            size: 30,
          )
        ],
      ),
    );
  }
}

Widget _buildTampilkanPlaylist() {
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
          Icons.list_rounded,
          size: 41,
          color: Colors.white,
        ),
        SizedBox(
          width: 5,
        ),
        Text("Daftar Playlist",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white))
      ],
    ),
  );
}

class lastPlayed extends StatelessWidget {
  final SongProvider iniListLagu;
  final int currIdx;

  const lastPlayed({Key? key, required this.iniListLagu, required this.currIdx})
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
                        listSong: songArr,
                        song: songArr[currIdx],
                        currIndex: currIdx);
                  }));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          iniListLagu.image,
                          height: 60,
                          width: 60,
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
                            iniListLagu.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD2AFFF),
                            ),
                          ),
                          Text(
                            iniListLagu.artist,
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
              Icon(Icons.more_vert_rounded, color: Color(0xFFD2AFFF), size: 30),
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
