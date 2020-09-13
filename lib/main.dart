import 'package:News_App/newsapp/components/AppBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:News_App/newsapp/NewsDetails.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:News_App/newsapp/modal/NewsModal.dart';

import 'dart:convert';

Future<NewsResponse> fetchNews() async {
  final response = await http.get(
      'https://newsapi.org/v2/top-headlines?country=in&apiKey=');

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
        appBar: buildAppBar(),
        body: RefreshIndicator(
          onRefresh: refreshNews,
          child: Center(
            child: FutureBuilder<NewsResponse>(
              future: newsResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var newsResponse = snapshot.data;
                  var articles = newsResponse.articles;
                  var crossAxisCount = MediaQuery.of(context).size.width/350;
                  return new StaggeredGridView.count(
                    crossAxisCount: crossAxisCount.floor(),
                    staggeredTiles: articles
                        .map<StaggeredTile>((_) => StaggeredTile.fit(1))
                        .toList(),
                      controller: _scrollController,
                      children: articles
                          .map(
                            (article) => InkWell(
                              onTap: ()=>{
                                Navigator.pushNamed(context, NewsDetails.routeNewsDetails,arguments : article)
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 150,
                                      maxWidth: 700
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
                                          shrinkWrap: true,
                                          physics: new NeverScrollableScrollPhysics(),
                                          children: [
                                            ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(horizontal: 8.0),
                                              title: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 8.0),
                                                child: AutoSizeText(
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
                                              subtitle: AutoSizeText(
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
                                                        minWidth: 250.0),
                                                    child: new Image.network(
                                                        article.urlToImage)),
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: ConstrainedBox(
                                                    constraints:
                                                        BoxConstraints(),
                                                    child: AutoSizeText(
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
                            ),
                          )
                          .toList(),
                    );
                } else if (snapshot.hasError) {
                  return AutoSizeText("${snapshot.error}");
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
