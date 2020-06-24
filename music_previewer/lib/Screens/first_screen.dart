import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_previewer/Screens/albums_screen.dart';
import 'package:music_previewer/Widgets/album.dart';
import 'package:music_previewer/Widgets/chart.dart';
import 'package:music_previewer/Widgets/radio.dart';
import 'package:music_previewer/utils/network_dataparser.dart';

List _radioData;
List _chartData;
Map _albumData;
Map _marsh;
Map _martin;
Map _daftPunk;
Map _rihanna;

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
    this._getAlbum();
    this._getmarsh();
    this._getMartin();
    this._daftpunk();
    this._geRihanna();
  }

  Future _getAlbum() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/119606");
    if (this.mounted) {
      setState(() {
        response.statusCode == 200 ? _albumData = response.data : null;
      });
    }
    print(_albumData['tracks']['data'].length);
  }

  Future _getmarsh() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/138472122");
    if (this.mounted) {
      setState(() {
        response.statusCode == 200 ? _marsh = response.data : null;
      });
    }
  }

  Future _geRihanna() async {
    var dio = Dio();
    Response response =
        await dio.get("https://api.deezer.com/album/15319389");
    if (this.mounted) {
      setState(() {
        response.statusCode == 200 ? _rihanna = response.data : null;
      });
    }
  }

  Future _daftpunk() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/302127");
    if (this.mounted) {
      setState(() {
        response.statusCode == 200 ? _daftPunk = response.data : null;
      });
    }
  }

  Future _getMartin() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/97081012");
    if (this.mounted) {
      setState(() {
        response.statusCode == 200 ? _martin = response.data : null;
      });
    }
  }

  Future _getRadio() async {
    var dio = Dio();

    Response response = await dio.get("https://api.deezer.com/radio");
    if (this.mounted) {
      setState(() {
        response.statusCode == 200 ? _radioData = response.data['data'] : null;
      });
    }
  }

  Future _getCharts() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/chart");
    if (this.mounted) {
      setState(() {
        response.statusCode == 200
            ? _chartData = response.data['tracks']['data']
            : null;
      });
    }
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
      _title("Top albums"),
      _redLine(context, MediaQuery.of(context).size.width / 2),
      InkWell(
        onTap: () {
          print(1);
        },
        child: _cardAlbum(),
      ),
      _title("Charts"),
      _redLine(context, MediaQuery.of(context).size.width / 3),
      _cardCharts(),
      _title("Radios"),
      _redLine(context, MediaQuery.of(context).size.width / 3),
      _cardRadio(),
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
      height: 300,
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
  return SizedBox(
      height: 300,
      child: _albumData != null &&
              _albumData.length > 0 &&
              _albumData.length != null
          ? ListView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                switch (index) {
                  case 0:
                    return InkWell(
                      onTap: () {
                        DataParser.singleAlbum = _albumData;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumScreen()));
                      },
                      child: Row(
                        children: <Widget>[
                          Album(
                              imageurl: _albumData['cover_xl'] != null
                                  ? _albumData['cover_xl']
                                  : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                              title: _albumData['title']),
                          SizedBox(height: 10, width: 10),
                        ],
                      ),
                    );
                    break;
                  case 1:
                    return InkWell(
                      onTap: () {
                        DataParser.singleAlbum = _marsh;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumScreen()));
                      },
                      child: Row(
                        children: <Widget>[
                          Album(
                              imageurl: _marsh['cover_xl'] != null
                                  ? _marsh['cover_xl']
                                  : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                              title: _marsh['title']),
                          SizedBox(height: 10, width: 10),
                        ],
                      ),
                    );
                    break;
                  case 2:
                    return InkWell(
                      onTap: () {
                        DataParser.singleAlbum = _martin;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumScreen()));
                      },
                      child: Row(
                        children: <Widget>[
                          Album(
                              imageurl: _martin['cover_xl'] != null
                                  ? _martin['cover_xl']
                                  : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                              title: _martin['title']),
                          SizedBox(
                            height: 10,
                            width: 10,
                          )
                        ],
                      ),
                    );
                    break;
                  case 3:
                    return InkWell(
                      onTap: () {
                        DataParser.singleAlbum = _daftPunk;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumScreen()));
                      },
                      child: Row(
                        children: <Widget>[
                          Album(
                              imageurl: _daftPunk['cover_xl'] != null
                                  ? _daftPunk['cover_xl']
                                  : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                              title: _daftPunk['title']),
                          SizedBox(height: 10, width: 10),
                        ],
                      ),
                    );
                    break;
                  case 4:
                    return InkWell(
                      onTap: () {
                        DataParser.singleAlbum = _rihanna;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumScreen()));
                      },
                      child: Row(
                        children: <Widget>[
                          Album(
                              imageurl: _rihanna['cover_xl'] != null
                                  ? _rihanna['cover_xl']
                                  : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                              title: _rihanna['title']),
                          SizedBox(
                            height: 10,
                            width: 10,
                          ),
                        ],
                      ),
                    );
                    break;
                  default:
                    return Album(
                        imageurl: _albumData['cover_xl'] != null
                            ? _albumData['cover_xl']
                            : "https://e-cdns-images.dzcdn.net/images/misc/235ec47f2b21c3c73e02fce66f56ccc5/1000x1000-000000-80-0-0.jpg",
                        title: _albumData['title']);
                }
              })
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
                      imageurl: _chartData[index]['artist']['picture_xl'] !=
                              null
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

Widget _redLine(BuildContext context, double width) {
  return Align(
      alignment: Alignment.bottomLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 10,
          width: width,
          color: Color(0xFFe81029),
        ),
      ));
}
