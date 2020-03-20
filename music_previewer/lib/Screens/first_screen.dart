import 'dart:convert';
import 'package:music_previewer/Screens/single_track.dart';
import 'package:music_previewer/utils/network_dataparser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool isSearching = false;

  TextEditingController appBarController = TextEditingController();

  var convertJsonToData;
  http.Response respose;

  @override
  void initState() {
    super.initState();
    this.getResult(
        "https://deezerdevs-deezer.p.rapidapi.com/search?q=${DataParser.query}");
  }

  // static String query = appBarController.text;

  // String apiUrl = "https://deezerdevs-deezer.p.rapidapi.com/search?q=${DataParser.query}";
  Future<Map<String, dynamic>> getResult(apiUrl) async {
    respose = await http.get(apiUrl, headers: {
      "Content-Type": "application/json",
      "x-rapidapi-key": "5df91adb64msh026a9441410fb94p1e0a92jsn9512838ab7d5",
    });

    if (this.mounted) {
      setState(() {
        convertJsonToData = json.decode(respose.body)['data'];
      });
    }
    // print(json.decode(respose.body)['data'][0]['artist']);
    return json.decode(respose.body);
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          title: !isSearching
              ? Text("Previx")
              : TextField(
                  controller: appBarController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter the artist name",
                    icon: Icon(Icons.search),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        this.isSearching = false;
                      });
                      DataParser.query = appBarController.text;
                      getResult(
                          "https://deezerdevs-deezer.p.rapidapi.com/search?q=${DataParser.query}");
                      // print(apiUrl);
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        this.isSearching = true;
                      });
                    },
                  )
          ],
        ),
        body: _body());
  }

  Widget _body() {
    if (DataParser.query == null) {
      return Container(
        child: Center(
          child: Icon(
            Icons.music_note,
            size: 300,
            color: Colors.indigo,
          ),
        ),
      );
    } else {
      return convertJsonToData != null &&
              convertJsonToData.length != null &&
              convertJsonToData.length > 0
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: convertJsonToData.length != null
                  ? convertJsonToData.length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  splashColor: Colors.indigo,
                  onTap: () {
                    DataParser.trackId = convertJsonToData[index]['id'];
                    DataParser.albumId =
                        convertJsonToData[index]['album']['id'];
                    DataParser.artistId =
                        convertJsonToData[index]['artist']['id'];
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SingleTrack()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(convertJsonToData[index]
                                      ['album']['cover_xl']),
                                  fit: BoxFit.fitWidth)),
                        ),
                        ListTile(
                          leading: Text("Song titile : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          title: Text(
                            convertJsonToData[index]['title'],
                          ),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.play_circle_filled,
                                color: Colors.indigo,
                              ),
                              onPressed: () => _launchURL(
                                  convertJsonToData[index]['preview'])),
                        )
                      ],
                    ),
                  ),
                );
              })
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
    }
  }
}
