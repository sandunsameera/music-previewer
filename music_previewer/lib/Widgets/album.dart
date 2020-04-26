import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_previewer/Screens/albums_screen.dart';

class Album extends StatelessWidget {
  final String imageurl;
  final String title;

  Album({this.imageurl, this.title});

  void _nav(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AlbumScreen()));
  }

  @override
  Widget build(context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: _boxes(this.imageurl, this.title),
        ),
      ],
    );
  }

  Widget _boxes(String _image, String _title) {
    return Container(
      child: new FittedBox(
        child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(_image),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: SafeArea(
                      child: Text(
                        _title,
                        style: GoogleFonts.balooTamma(fontSize: 20),
                      ),
                    )),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
