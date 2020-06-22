import 'package:flutter/material.dart';

class ChartsScreen extends StatefulWidget {
  final String id;
  const ChartsScreen({Key key, @required this.id}) : super(key: key);
  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _chartScreen(),
    );
  }

  Widget _chartScreen() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 8),
        Center(
          child: Text(widget.id),
        )
      ],
    );
  }
}
