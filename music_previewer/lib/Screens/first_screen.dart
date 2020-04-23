import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_previewer/Widgets/album.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }
}

Widget _body(BuildContext context) {
  return ListView(
    children: <Widget>[
      SizedBox(height: 10),
      _searchBar(),
      _title("Album"),
      _redLine(context),
      _card(),
      _title("Radios"),
      _redLine(context),
      _card(),
      _title("Charts"),
      _redLine(context),
      _card(),
    ],
  );
}

Widget _searchBar() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextField(
      onChanged: (val) {},
      decoration: InputDecoration(
          prefixIcon: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            iconSize: 20.0,
            onPressed: () {},
          ),
          contentPadding: EdgeInsets.only(left: 25.0),
          hintText: 'Search by Artist name or track name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
    ),
  );
}

Widget _card() {
  return Container(
    height: 200,
    child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) => Album(
              imageurl:
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/WUSL012.jpg/330px-WUSL012.jpg",
              name: "lfsnfk",
            )),
  );
}

Widget _title(String title) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Text(
      title,
      style: GoogleFonts.pacifico(fontSize: 40),
    ),
  );
}

Widget _redLine(BuildContext context) {
  return Align(
      alignment: Alignment.bottomLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width / 3,
          color: Color(0xFFe81029),
        ),
      ));
}
