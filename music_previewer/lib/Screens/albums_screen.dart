import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumsScreen extends StatefulWidget {
  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  @override
  Widget build(BuildContext context) {
    return _albumBody(context);
  }
}

Widget _albumBody(BuildContext context) {
  return Container(
    child: Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 30)),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Albums",
            style: GoogleFonts.pacifico(fontSize: 40),
          ),
        ),
        Align(
            alignment: Alignment.bottomLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 10,
                width: MediaQuery.of(context).size.width / 3,
                color: Color(0xFFe81029),
              ),
            )),
        _buildContainer(),
      ],
    ),
  );
}

Widget _buildContainer() {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        height: 204.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: _boxes(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/WUSL012.jpg/330px-WUSL012.jpg",
                    ),
                  ),
                ],
              );
            })),
  );
}

Widget _boxes(
  String _image,
) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      child: new FittedBox(
        child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Row(
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
                      child: Text("Fucking title"),
                    ),
                  ),
                ),
              ],
            )),
      ),
    ),
  );
}
