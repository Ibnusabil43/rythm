import 'package:flutter/material.dart';
import 'package:rythm/FtechFromFirebase/FtechSongFromFirebase.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:rythm/screen/Play.dart';

class SongGenre extends StatefulWidget {
  final String genreName;
  const SongGenre({super.key, required this.genreName});

  @override
  State<SongGenre> createState() => _SongGenreState();
}

class _SongGenreState extends State<SongGenre> {
  @override
  void initState() {
    super.initState();
    _initializeSongs();
  }

  void _initializeSongs() async {
    try {
      songGen = [];
      songArr = await ftechSongsFromFirebase();
      print("Songs fetched successfully:");
      for (var song in songArr) {
        if (song.genre == widget.genreName) {
          songGen.add(song);
        }
      }
      // print(songArr);
      setState(() {});
    } catch (e) {
      print("Error fetching songs: $e");
    }
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
              widget.genreName,
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: songGen.length,
          itemBuilder: (context, index) {
            return songListThisGenre(
              iniListLagu: songGen[index],
              currIdx: index,
            );
          },
        ),
      ),
    );
  }
}

class songListThisGenre extends StatelessWidget {
  final SongProvider iniListLagu;
  final int currIdx;

  const songListThisGenre(
      {Key? key, required this.iniListLagu, required this.currIdx})
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
                    if (songGen.isNotEmpty && currIdx < songGen.length) {
                      return Play(
                        listSong: songGen,
                        song: songGen[currIdx],
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
