import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chart extends StatelessWidget {
  final String imageurl;
  final String title;

  Chart({this.imageurl, this.title});

  @override
  Widget build(BuildContext context) {
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
      height: 250,
      child: new FittedBox(
        child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                Container(
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Center(
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 150,
                  child: Center(
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
                  ),
                )
              ],
            )),
      ),
    );
  }
}
