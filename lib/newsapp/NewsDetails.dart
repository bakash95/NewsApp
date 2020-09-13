import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:News_App/newsapp/modal/NewsModal.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetails extends StatelessWidget{

  static const String routeNewsDetails = '/newsDetails';

  @override
  Widget build(BuildContext context) {
    Articles _articles = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(_articles.title),
      ),
      body: WebView(
        initialUrl: _articles.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

}