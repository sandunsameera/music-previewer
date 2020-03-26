import 'dart:async';
import 'dart:convert';
import 'package:audioplayer/audioplayer.dart';
import 'package:image_fade/image_fade.dart';
import 'package:music_previewer/Screens/single_track.dart';
import 'package:music_previewer/utils/network_dataparser.dart';
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

  @override
  void initState() {
    super.initState();
    // this.appBarController.text = "";
    this.isMuted = false;
    this.initAudioPlayer();
    this.duration = Duration(microseconds: 1);
    this.getResult(
        "https://deezerdevs-deezer.p.rapidapi.com/search?q=${DataParser.query}");
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future play(url) async {
    await audioPlayer.play(url);
    setState(() {
      playerState = PlayerState.playing;
      isMuted = false;
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
    return json.decode(respose.body);
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
          height: 50,
          width: 100,
          child: Column(
            children: [
              new Text("Searching your query.."),
              new CircularProgressIndicator(),
            ],
          ),
        ));
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

  void showBottomModel(index) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF0A79DF),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                duration == null
                    ? new Container()
                    : new Slider(
                        activeColor: Color(0xFF192A56),
                        value: position?.inMilliseconds?.toDouble() ?? 0,
                        onChanged: (double value) =>
                            audioPlayer.seek((value / 1000).roundToDouble()),
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble()),
                new Row(mainAxisSize: MainAxisSize.min, children: [
                  new Text(
                      position != null
                          ? "${positionText ?? ''} / ${durationText ?? ''}"
                          : duration != null ? durationText : '',
                      // ignore: conflicting_dart_import
                      style: new TextStyle(fontSize: 14.0))
                ]),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.volume_mute),
                          onPressed: () => mute(true)),
                      IconButton(
                          icon: Icon(Icons.play_circle_filled),
                          onPressed: () =>
                              play(convertJsonToData[index]['preview'])),
                      IconButton(
                          icon: Icon(Icons.stop), onPressed: () => stop())
                    ],
                  ),
                )
              ],
            ),
          );
        });
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
                        MaterialPageRoute(builder: (context) => SingleTrack()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: <Widget>[
                        ImageFade(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                          image: NetworkImage(
                              convertJsonToData[index]['album']['cover_xl']),
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Widget child,
                              dynamic exception) {
                            return Container(
                              color: Color(0xFF6F6D6A),
                              child: Center(
                                  child: Icon(Icons.music_video,
                                      color: Colors.black26, size: 128.0)),
                            );
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent event) {
                            if (event == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                  value: event.expectedTotalBytes == null
                                      ? 0.0
                                      : event.cumulativeBytesLoaded /
                                          event.expectedTotalBytes),
                            );
                          },
                          placeholder: Container(
                            color: Color(0xFFCFCDCA),
                            child: Center(
                                child: Icon(
                              Icons.photo,
                              color: Colors.white30,
                              size: 128.0,
                            )),
                          ),
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
                                showBottomModel(index);
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