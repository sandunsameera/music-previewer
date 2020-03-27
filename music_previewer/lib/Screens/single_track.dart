import 'dart:async';
import 'dart:convert';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:music_previewer/Screens/first_screen.dart';
import 'package:music_previewer/utils/network_dataparser.dart';
import 'package:http/http.dart' as http;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SingleTrack extends StatefulWidget {
  @override
  _SingleTrackState createState() => _SingleTrackState();
}

class _SingleTrackState extends State<SingleTrack> {
  String apiUrl =
      "https://deezerdevs-deezer.p.rapidapi.com/track/${DataParser.trackId}";

  var convertJsonToData;
  http.Response respose;

  final double _initFabHeight = 120.0;
  double _panelHeightOpen;
  double _panelHeightClosed = 45.0;

  //audio player
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
    return json.decode(respose.body);
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

  @override
  void initState() {
    super.initState();
    this.getResult();
    this.duration = Duration(milliseconds: 1);
    this.initAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return Material(
      child: SlidingUpPanel(
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .5,
        body: _body(),
        panelBuilder: (sc) => _panel(sc),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
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
              convertJsonToData != null
                  ? convertJsonToData['title']
                  : "Loading",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 16,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              convertJsonToData != null
                  ? convertJsonToData['album']['cover_xl']
                  : "",
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          ListTile(
            trailing: Text(
              convertJsonToData != null
                  ? convertJsonToData['duration'].toString()
                  : "Loading",
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
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                      convertJsonToData != null
                          ? convertJsonToData['artist']['name']
                          : "Loading",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 32,
                ),
                ListTile(
                  leading: Text("Released date",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  trailing: Text(
                      convertJsonToData != null
                          ? convertJsonToData['release_date']
                          : "Still loading",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 32,
                ),
                ListTile(
                  leading: Text("Album",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  trailing: Text(
                      convertJsonToData != null
                          ? convertJsonToData['album']['title']
                          : "Still loading",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 32,
                ),
                ListTile(
                    leading: Text("Play full track",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: Colors.black,
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              convertJsonToData != null
                  ? convertJsonToData['title']
                  : "Still loading",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ImageFade(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height / 4,
              image: NetworkImage(convertJsonToData != null
                  ? convertJsonToData['album']['cover_xl']
                  : ""),
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Widget child, dynamic exception) {
                return Container(
                  color: Color(0xFF6F6D6A),
                  child: Center(
                      child: Icon(Icons.music_video,
                          color: Colors.black26, size: 128.0)),
                );
              },
              loadingBuilder:
                  (BuildContext context, Widget child, ImageChunkEvent event) {
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
            SizedBox(height: 30),
            duration == null
                ? new Container()
                : new Slider(
                    activeColor: Color(0xFFBA2F16),
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
                  style: new TextStyle(fontSize: 18.0))
            ]),
            new Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.headset_off,
                        size: 40,
                      ),
                      onPressed: () => mute(true)),
                  IconButton(
                      icon: Icon(
                        Icons.play_circle_filled,
                        size: 40,
                        color: Color(0xFF192A56),
                      ),
                      onPressed: () => play(convertJsonToData['preview'])),
                  IconButton(
                      icon: Icon(
                        Icons.stop,
                        size: 40,
                      ),
                      onPressed: () => stop())
                ],
              ),
            )
          ],
        ));
  }
}
