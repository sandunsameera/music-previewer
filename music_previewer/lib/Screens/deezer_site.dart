import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_previewer/utils/network_dataparser.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DeezerSite extends StatefulWidget {
  @override
  _DeezerSiteState createState() => _DeezerSiteState();
}

class _DeezerSiteState extends State<DeezerSite> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Powerd by deezer.api"),
        backgroundColor: Color(0xFF192A56),
      ),

      body: WebView(
        initialUrl: "https://www.youtube.com/results?search_query=${DataParser.songUrl}",
        javascriptMode: JavascriptMode.unrestricted,
        debuggingEnabled: true,
        onWebViewCreated: (WebViewController webViewController){
          _controller.complete(webViewController);
        },
      ),
    );
  }
}