import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:News_App/newsapp/NewsDetails.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:News_App/newsapp/modal/NewsModal.dart';

import 'dart:convert';

Future<NewsResponse> fetchNews() async {
  final response = await http.get(
      'https://newsapi.org/v2/top-headlines?country=in&apiKey=4e2d9df2092d4088ab8e13c2470e2073');

  if (response.statusCode == 200) {
    return NewsResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load news');
  }
}

void main() {
  runApp(NewsHomePage());
}

class NewsHomePage extends StatefulWidget {
  @override
  _NewsApp createState() => _NewsApp();
}

class _NewsApp extends State<NewsHomePage> {
  ScrollController _scrollController = new ScrollController();
  Future<NewsResponse> newsResponse;

  @override
  void initState() {
    super.initState();
    newsResponse = fetchNews();
  }

  Future<String> refreshNews(){
    newsResponse = fetchNews();
    return Future.value('success');
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xfffe4066),
    ));

    return MaterialApp(
      color: Colors.white,
      routes: {
        NewsDetails.routeNewsDetails: (context) => NewsDetails(),
      },
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffe4066),
          elevation : 0,
          title: Center(
              child: Text(
            'News App',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
              color: Colors.white,
            ),
          )),
        ),
        body: RefreshIndicator(
          onRefresh: refreshNews,
          child: Center(
            child: FutureBuilder<NewsResponse>(
              future: newsResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var newsResponse = snapshot.data;
                  var articles = newsResponse.articles;
                  return ListView(
                      controller: _scrollController,
                      children: articles
                          .map(
                            (article) => InkWell(
                              onTap: ()=>{
                                Navigator.pushNamed(context, NewsDetails.routeNewsDetails,arguments : article)
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: 150.0,
                                    maxHeight: 450,
                                  ),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor: Color(0xfffe4066),
                                    elevation: 2.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ListView(
                                        physics: new NeverScrollableScrollPhysics(),
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(horizontal: 8.0),
                                            title: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                              child: Text(
                                                article.title,
                                                style: GoogleFonts.merriweather(
                                                  color: Color(0xffe91e63),
                                                  textStyle: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff424242),
                                                    decorationStyle:
                                                        TextDecorationStyle.solid,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            subtitle: Text(
                                              article.author != null
                                                  ? article.author
                                                  : "",
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                          if (article.urlToImage != null)
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 200.0,
                                                      maxWidth: double.infinity),
                                                  child: new Image.network(
                                                      article.urlToImage)),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Center(
                                              child: ConstrainedBox(
                                                  constraints:
                                                      BoxConstraints(maxHeight: 250),
                                                  child: Text(
                                                    article.description != null
                                                        ? article.description
                                                        : "",
                                                    style: GoogleFonts.lato(),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Color(0xfffe4066),
          child: new Icon(Icons.arrow_upward),
            onPressed: (){
          _scrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
        }),
      ),
    );
  }
}
