import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_previewer/Widgets/chart.dart';
import 'package:music_previewer/Widgets/radio.dart';

List _radioData;
List _chartData;

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    this._getRadio();
    this._getCharts();
  }

  Future _getRadio() async {
    var dio = Dio();

    Response response = await dio.get("https://api.deezer.com/radio");
    _radioData = response.data['data'];
    // print(_radioData);
  }

  Future _getCharts() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/chart");
    _chartData = response.data['tracks']['data'];
    print(_chartData[0]['artist']['picture_xl']);
  }

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
      _cardAlbum(),
      _title("Radios"),
      _redLine(context),
      _cardRadio(),
      _title("Charts"),
      _redLine(context),
      _cardCharts()
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

Widget _cardRadio() {
  return Container(
      height: 230,
      child: _radioData != null &&
              _radioData.length > 0 &&
              _radioData.length != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _radioData.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: <Widget>[
                    RadioWidget(
                      imageurl: _radioData[index]['picture_xl'] != null
                          ? _radioData[index]['picture_xl']
                          : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                      title: _radioData[index]['title'],
                    ),
                    SizedBox(height: 10, width: 10),
                  ],
                );
              })
          : Container(child: Text("Fucked")));
}

Widget _cardAlbum() {
  return Container(
      height: 230,
      child: _radioData != null &&
              _radioData.length > 0 &&
              _radioData.length != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _radioData.length,
              itemBuilder: (BuildContext context, int index) => RadioWidget(
                    imageurl: _radioData[index]['picture_xl'] != null
                        ? _radioData[index]['picture_xl']
                        : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                    title: _radioData[index]['title'],
                  ))
          : Container(child: Text("Fucked")));
}

Widget _cardCharts() {
  return Container(
      height: 230,
      child: _chartData != null &&
              _chartData.length > 0 &&
              _chartData.length != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _chartData.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: <Widget>[
                    Chart(
                      imageurl: _chartData[index]['artist']['picture_xl'] != null
                          ? _chartData[index]['artist']['picture_xl']
                          : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                      title: _chartData[index]['title'],
                    ),
                    SizedBox(height: 10, width: 10),
                  ],
                );
              })
          : Container(child: Text("Fucked")));
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
