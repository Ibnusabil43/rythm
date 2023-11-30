// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rythm/FtechFromFirebase/FtechSongFromFirebase.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:rythm/screen/Genre/GenreList.dart';
import 'package:rythm/screen/Play.dart';
import 'package:rythm/screen/Playlist/listPlaylist.dart';
import 'package:rythm/screen/Search Song/searchLagu.dart';
import 'package:rythm/providers/userProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeSongs();
  }

  void _initializeSongs() async {
    try {
      songArr = await ftechSongsFromFirebase();
      print("Songs fetched successfully:");
      // print(songArr);
      setState(() {});
    } catch (e) {
      print("Error fetching songs: $e");
    }
  }

  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour >= 0 && hour < 5) {
      return 'Malam';
    } else if (hour >= 5 && hour < 12) {
      return 'Pagi';
    } else if (hour >= 12 && hour < 17) {
      return 'Siang';
    } else {
      return 'Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();
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
              'Selamat $greeting ${context.watch<UsersProvider>().username}',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 20,
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenreList()),
                );
              },
              child: _buildgenre(),
            ),
            SizedBox(
              height: 20,
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
              height: 20,
            ),
            Text(
              "Terakhir Diputar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD2AFFF),
              ),
            ),
            SizedBox(
              height: 5,
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

  Widget _buildTampilkanPlaylist() {
    return Container(
      width: double.infinity,
      height: 61,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xffd2afff),
      ),
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
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white))
        ],
      ),
    );
  }

  Widget _buildgenre() {
    return Stack(
      children: [
        // Container untuk gambar dengan gradient
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/genreimg.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        // Container untuk gradient
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFFD2AFFF),
              ],
              stops: [0.0, 0.69],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'GENRE\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: 'gen·re',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text:
                          '/ /génre/ \njenis, tipe, atau \nkelompok sastra atas \ndasar bentuknya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Jelajahi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
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
                    //songArr = context.watch<SongProvider>().songArray;
                    print(songArr);
                    if (songArr.isNotEmpty && currIdx < songArr.length) {
                      return Play(
                        listSong: songArr,
                        song: songArr[currIdx],
                        currIndex: currIdx,
                      );
                    } else {
                      // Handle the case where the list is empty or the index is out of bounds
                      // You can show an error message or navigate to a default screen.
                      return Scaffold(
                        body: Center(
                          child: Text('Error: Invalid index or empty list'),
                        ),
                      );
                    }
                  }));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Image.network(
                          iniListLagu.image,
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
