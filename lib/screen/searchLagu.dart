import 'package:flutter/material.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:rythm/screen/Play.dart';

List<SongProvider> filteredSongs = [];

class SearchLagu extends StatefulWidget {
  const SearchLagu({Key? key}) : super(key: key);

  @override
  _SearchLaguState createState() => _SearchLaguState();
}

class _SearchLaguState extends State<SearchLagu> {
  String searchString = ''; // Variabel penyimpanan string pencarian

  @override
  Widget build(BuildContext context) {
    filterSongs(); // Filter daftar lagu berdasarkan pencarian

    return Scaffold(
      backgroundColor: Color(0xFF1C1C27),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              'Cari Lagu',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              width: 33,
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 18,
            ),
            formCari(),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  return songSearchResult(
                    iniListLagu: filteredSongs[index],
                    currIdx: index,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
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
        onChanged: (value) {
          setState(() {
            searchString = value; // Update string pencarian saat nilai berubah
          });
        },
      ),
    );
  }

  void filterSongs() {
    filteredSongs = songArr
        .where((song) =>
            song.title.toLowerCase().contains(searchString.toLowerCase()))
        .toList();
  }
}

class songSearchResult extends StatelessWidget {
  final SongProvider iniListLagu;
  final int currIdx;

  const songSearchResult(
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
                    return Play(
                        listSong: songArr,
                        song: filteredSongs[currIdx],
                        currIndex: songArr.indexOf(filteredSongs[currIdx]));
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
