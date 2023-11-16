import 'package:flutter/material.dart';
import 'package:rythm/providers/songProvider.dart';
import '../providers/playlistProvider.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';

class songListToAdd extends StatefulWidget {
  final PlayListProvider playlist;
  const songListToAdd({Key? key, required this.playlist}) : super(key: key);

  @override
  State<songListToAdd> createState() => _songListToAddState();
}

class _songListToAddState extends State<songListToAdd> {
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
                "Song To Add",
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 18,
            ),
            formCari(),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songArr.length,
                itemBuilder: (context, index) {
                  if (index <= songArr.length) {
                    return SongWidget(
                      song: songArr[index],
                      playlist: widget.playlist,
                    );
                  }
                },
              ),
            )
          ]),
        ));
  }

  Widget formCari() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: ShapeDecoration(
        color: Color(0xFF313142),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: TextField(
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFFD2AFFF),
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Color(0xFFD2AFFF),
          ),
        ),
      ),
    );
  }
}

class SongWidget extends StatefulWidget {
  final SongProvider song;
  final PlayListProvider playlist;

  SongWidget({Key? key, required this.song, required this.playlist})
      : super(key: key);

  bool isTapped = false;

  @override
  _SongWidgetState createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  bool isAdded = false; // Track whether the song is added

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: () {
          // Handle onTap action here
          setState(() {
            isAdded = !isAdded; // Toggle the added state
          });
          context.read<UsersProvider>().tambahLagukePlaylist(
              playlist: widget.playlist, song: widget.song);
          Navigator.pop(context);
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  child: Image.asset(
                    widget.song.image,
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
                      widget.song.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD2AFFF),
                      ),
                    ),
                    Text(
                      widget.song.artist,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFD2AFFF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            isAdded ? Icons.check_circle_rounded : Icons.add_circle_rounded,
            color: Color(0xFFD2AFFF),
            size: 30,
          ),
        ]),
      ),
      SizedBox(height: 10)
    ]);
  }
}
