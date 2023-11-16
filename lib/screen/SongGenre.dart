import 'package:flutter/material.dart';

class SongGenre extends StatefulWidget {
  final String genreName;
  const SongGenre({super.key, required this.genreName});

  @override
  State<SongGenre> createState() => _SongGenreState();
}

class _SongGenreState extends State<SongGenre> {
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
    );
  }
}
