import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_previewer/utils/network_dataparser.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

enum PlayerState { stopped, playing, paused }
const Color backgroundColor = Color(0xffE7E8E8);
const Color dotColor = Color(0xff2a356d);

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final String kUrl = DataParser.previewSong["preview"];
  Duration duration;
  Duration position;

  MusicFinder audioPlayer;

  Icon playIcon = Icon(Icons.play_arrow);

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  Future initAudioPlayer() async {
    audioPlayer = new MusicFinder();
    var songs;
    try {
      songs = await MusicFinder.allSongs();
    } catch (e) {
      print(e.toString());
    }

    print(songs);
    audioPlayer.setDurationHandler((d) => setState(() {
          duration = d;
        }));

    audioPlayer.setPositionHandler((p) => setState(() {
          position = p;
        }));

    audioPlayer.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
      });
    });

    audioPlayer.setErrorHandler((msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
    setState(() {
      print(songs.toString());
    });
  }

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = PlayerState.stopped;
        position = new Duration();
      });
  }

  Future mute(bool muted) async {
    final result = await audioPlayer.mute(muted);
    if (result == 1)
      setState(() {
        isMuted = muted;
      });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
  }

  Future play() async {
    final result = await audioPlayer.play(kUrl);
    if (result == 1)
      setState(() {
        print('_AudioAppState.play... PlayerState.playing');
        playerState = PlayerState.playing;
      });
  }

  double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Stack(
          children: <Widget>[
            _albumArt(),
            _seekBar(),
            _musicTitle(),
            _bottomButtons(),
            Positioned(top: 40, left: 8.0, child: Icon(Icons.arrow_back_ios)),
            Positioned(top: 40, right: 8.0, child: Icon(Icons.list))
          ],
        ),
      ),
    );
  }

  Widget _bottomButtons() => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 0.22 * height,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Text("Fuck"),
              Expanded(
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.shuffle),
                      Expanded(
                        child: _musicControls(),
                      ),
                      Icon(Icons.repeat),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget _musicControls() => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.fast_rewind),
                    SizedBox(width: 120),
                    Icon(Icons.fast_forward)
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              play();

              setState(() {
                playerState = PlayerState.paused;
              });
            },
            child: CircleAvatar(
                radius: 35,
                backgroundColor: dotColor,
                child: playerState == PlayerState.stopped || playerState == PlayerState.paused ? Icon(Icons.play_arrow):Icon(Icons.pause)),
          ),
        ],
      );

  Widget _musicTitle() => Positioned(
        bottom: 0.4 * height,
        left: 55,
        right: 55,
        child: Column(
          children: <Widget>[
            Text(
              DataParser.playingSong,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DataParser.artist,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      );

  Widget _seekBar() => Positioned(
        left: 0,
        right: 0,
        bottom: 0.25 * height,
        child: SleekCircularSlider(
          min: 0,
          max: 100,
          initialValue: 0,
          onChange: (value) {},
          onChangeEnd: (value) {},
          onChangeStart: (value) {},
          innerWidget: (value) => Container(),
          appearance: CircularSliderAppearance(
              startAngle: 0,
              angleRange: 180,
              size: width - 50,
              customWidths: CustomSliderWidths(
                  progressBarWidth: 4.0, trackWidth: 4.0, handlerSize: 8.0),
              customColors: CustomSliderColors(
                  progressBarColor: Colors.grey,
                  trackColor: dotColor,
                  dotColor: dotColor)),
        ),
      );

  Widget _albumArt() => Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(
          left: 50,
          right: 50,
          bottom: 0.3 * height,
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(DataParser.singleAlbum['cover_xl']),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular((width - 100) / 2),
              bottomRight: Radius.circular((width - 100) / 2),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 8),
                  blurRadius: 5.0)
            ]),
      );
}
