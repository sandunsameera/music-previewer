import 'dart:convert';
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
  String apiUrl = "https://deezerdevs-deezer.p.rapidapi.com/search?q=eminem";

  var convertJsonToData;
  http.Response respose;

  Future<Map<String, dynamic>> getResult() async {
    respose = await http.get(apiUrl, headers: {
      "Content-Type": "application/json",
      "x-rapidapi-key": "5df91adb64msh026a9441410fb94p1e0a92jsn9512838ab7d5",
    });
    //  convertJsonToData['data'] = json.decode(respose.body);

    if (this.mounted) {
      setState(() {
        convertJsonToData = json.decode(respose.body)['data'];
      });
    }
    print(json.decode(respose.body)['data'][0]['artist']);
    return json.decode(respose.body);
  }

  @override
  void initState() {
    super.initState();
    this.getResult();
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
          title: !isSearching
              ? Text("Welcome to music-previewer")
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
                      getResult();
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
    return convertJsonToData != null &&
            convertJsonToData.length != null &&
            convertJsonToData.length > 0
        ? ListView.builder(
            itemCount:
                convertJsonToData.length != null ? convertJsonToData.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: (){
                        _launchURL(convertJsonToData[index]['preview']);
                      },
                        leading: ClipOval(
                          child: Image.network(
                            convertJsonToData[index]['artist']
                                        ['picuture_small'] !=
                                    null
                                ? convertJsonToData[index]['artist']
                                    ['picuture_small']
                                : "",
                            fit: BoxFit.cover,
                            width: 90.0,
                            height: 90.0,
                          ),
                        ),
                        title: Text(
                          convertJsonToData[index]['title'] != null
                              ? convertJsonToData[index]['title']
                              : "Loading",
                        )),
                  ],
                ),
              );
            },
          )
        : Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
