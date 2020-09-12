import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
  Future<NewsResponse> newsResponse;

  @override
  void initState() {
    super.initState();
    newsResponse = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          title: Center(
              child: Text(
            'News App',
            style: GoogleFonts.roboto(
              color: Color(0xfffe4066),
            ),
          )),
        ),
        body: Center(
          child: FutureBuilder<NewsResponse>(
            future: newsResponse,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var newsResponse = snapshot.data;
                var articles = newsResponse.articles;
                return ListView(
                  children: articles
                      .map(
                        (article) => Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 200.0,
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
                                              article.content != null
                                                  ? article.content
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
    );
  }
}

class NewsResponse {
  String _status;
  int _totalResults;
  List<Articles> _articles;

  NewsResponse({String status, int totalResults, List<Articles> articles}) {
    this._status = status;
    this._totalResults = totalResults;
    this._articles = articles;
  }

  String get status => _status;
  set status(String status) => _status = status;
  int get totalResults => _totalResults;
  set totalResults(int totalResults) => _totalResults = totalResults;
  List<Articles> get articles => _articles;
  set articles(List<Articles> articles) => _articles = articles;

  NewsResponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _totalResults = json['totalResults'];
    if (json['articles'] != null) {
      _articles = new List<Articles>();
      json['articles'].forEach((v) {
        _articles.add(new Articles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['totalResults'] = this._totalResults;
    if (this._articles != null) {
      data['articles'] = this._articles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Articles {
  Source _source;
  String _author;
  String _title;
  String _description;
  String _url;
  String _urlToImage;
  String _publishedAt;
  String _content;

  Articles(
      {Source source,
      String author,
      String title,
      String description,
      String url,
      String urlToImage,
      String publishedAt,
      String content}) {
    this._source = source;
    this._author = author;
    this._title = title;
    this._description = description;
    this._url = url;
    this._urlToImage = urlToImage;
    this._publishedAt = publishedAt;
    this._content = content;
  }

  Source get source => _source;
  set source(Source source) => _source = source;
  String get author => _author;
  set author(String author) => _author = author;
  String get title => _title;
  set title(String title) => _title = title;
  String get description => _description;
  set description(String description) => _description = description;
  String get url => _url;
  set url(String url) => _url = url;
  String get urlToImage => _urlToImage;
  set urlToImage(String urlToImage) => _urlToImage = urlToImage;
  String get publishedAt => _publishedAt;
  set publishedAt(String publishedAt) => _publishedAt = publishedAt;
  String get content => _content;
  set content(String content) => _content = content;

  Articles.fromJson(Map<String, dynamic> json) {
    _source =
        json['source'] != null ? new Source.fromJson(json['source']) : null;
    _author = json['author'];
    _title = json['title'];
    _description = json['description'];
    _url = json['url'];
    _urlToImage = json['urlToImage'];
    _publishedAt = json['publishedAt'];
    _content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._source != null) {
      data['source'] = this._source.toJson();
    }
    data['author'] = this._author;
    data['title'] = this._title;
    data['description'] = this._description;
    data['url'] = this._url;
    data['urlToImage'] = this._urlToImage;
    data['publishedAt'] = this._publishedAt;
    data['content'] = this._content;
    return data;
  }
}

class Source {
  String _id;
  String _name;

  Source({String id, String name}) {
    this._id = id;
    this._name = name;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;

  Source.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    return data;
  }
}
