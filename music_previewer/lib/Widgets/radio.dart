import 'package:flutter/material.dart';

class Radio extends StatelessWidget {
  final String imageurl;
  final String name;

  Radio({this.imageurl, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: _boxes(
            this.imageurl,
          ),
        ),
      ],
    );
  }

  Widget _boxes(
    String _image,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text("Fucking title"),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
