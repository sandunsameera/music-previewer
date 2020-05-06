import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_previewer/Screens/playing_screen.dart';
import 'package:music_previewer/utils/network_dataparser.dart';

class AlbumScreen extends StatefulWidget {
  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _albumSongs(),
    );
  }

  Widget _albumSongs() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 8),
        Center(
          child: Text(DataParser.singleAlbum['title'],
              style: GoogleFonts.balooTamma(
                  fontSize: 30, color: Color(0xff1c3975))),
        ),
        SizedBox(height: 8),
        GridView.count(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            primary: false,
            shrinkWrap: true,
            children: List<Widget>.generate(
                DataParser.singleAlbum['tracks']['data'].length, (index) {
              return buildResultCard(index);
            })),
      ],
    );
  }

  Widget buildResultCard(int index) {
    return InkWell(
      onTap: () {
        DataParser.playingSong =
            DataParser.singleAlbum['tracks']['data'][index]['title'];
        DataParser.artist =
            DataParser.singleAlbum['tracks']['data'][index]['artist']['name'];
        DataParser.previewSong =
            DataParser.singleAlbum['tracks']['data'][index];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerScreen()));
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Color(0xffbee1e2),
        elevation: 2.0,
        child: Stack(
          children: <Widget>[
            Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(DataParser.singleAlbum['cover_xl']),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                DataParser.singleAlbum['tracks']['data'][index]['title']
                    .toString(),
                style:
                    GoogleFonts.balooTamma(color: Colors.white, fontSize: 23),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
