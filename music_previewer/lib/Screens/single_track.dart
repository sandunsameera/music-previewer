import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:music_previewer/utils/network_dataparser.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SingleTrack extends StatefulWidget {
  @override
  _SingleTrackState createState() => _SingleTrackState();
}

class _SingleTrackState extends State<SingleTrack> {
  String apiUrl =
      "https://deezerdevs-deezer.p.rapidapi.com/track/${DataParser.trackId}";

  var convertJsonToData;
  http.Response respose;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Map<String, dynamic>> getResult() async {
    respose = await http.get(apiUrl, headers: {
      "Content-Type": "application/json",
      "x-rapidapi-key": "5df91adb64msh026a9441410fb94p1e0a92jsn9512838ab7d5",
    });

    if (this.mounted) {
      setState(() {
        convertJsonToData = json.decode(respose.body);
      });
    }
    print(json.decode(respose.body));
    return json.decode(respose.body);
  }

  @override
  void initState() {
    super.initState();
    this.getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 16,
          ),
          Center(
            child: Text(
              convertJsonToData!=null?convertJsonToData['title']:"Loading",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 16,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              convertJsonToData!=null?convertJsonToData['album']['cover_xl']:"",
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          ListTile(
            trailing: Text(
              convertJsonToData!=null?convertJsonToData['duration'].toString():"Loading",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    "Artist",
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(convertJsonToData!=null?convertJsonToData['artist']['name']:"Loading",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 32,
                ),
                ListTile(
                  leading: Text("Released date",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  trailing: Text(convertJsonToData!=null?convertJsonToData['release_date']:"Still loading",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 32,
                ),
                ListTile(
                  leading: Text("Album",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  trailing: Text(convertJsonToData!=null?convertJsonToData['album']['title']:"Still loading",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 32,
                ),
                ListTile(
                    leading: Text("Play full track",
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.play_circle_filled,
                          color: Colors.indigo,
                        ),
                        onPressed: () {
                          _launchURL(convertJsonToData['preview']);
                        })),
              ],
            ),
          )
        ],
      ),
    );
  }
}
