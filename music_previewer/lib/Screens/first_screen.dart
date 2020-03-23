import 'dart:async';
import 'dart:convert';
import 'package:audioplayer/audioplayer.dart';
import 'package:music_previewer/Screens/single_track.dart';
import 'package:music_previewer/Screens/test.dart';
import 'package:music_previewer/utils/network_dataparser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum PlayerState { stopped, playing, paused }

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool isSearching = false;
  String title = "Previx";
  TextEditingController appBarController = TextEditingController();

  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  var convertJsonToData;
  http.Response respose;

  @override
  void initState() {
    super.initState();
    // this.appBarController.text = "";
    this.getResult(
        "https://deezerdevs-deezer.p.rapidapi.com/search?q=${DataParser.query}");
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future play(url) async {
    await audioPlayer.play(url);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Column(
            children: [
              new Text("Searching your query.."),
              new CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 5), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF192A56),
          title: !isSearching
              ? Text(title)
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
                      //-------------------
                      _onLoading();
                      //-------------------
                      setState(() {
                        this.isSearching = false;
                        this.title = appBarController.text;
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
    if (DataParser.query == null && convertJsonToData != null) {
      return Container(
        child: Center(
          child: Icon(
            Icons.music_note,
            size: 300,
            color: Colors.grey,
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
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          // color: Color(0xFF),
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(convertJsonToData[index]
                                      ['album']['cover_xl']),
                                  fit: BoxFit.fitWidth)),
                        ),
                        ListTile(
                          leading: Text(convertJsonToData[index]['title'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.play_circle_filled,
                                color: Colors.indigo,
                              ),
                              onPressed: () {
                                // play(convertJsonToData[index]['preview']);
                                play(convertJsonToData[index]['preview']);
                              }),
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
