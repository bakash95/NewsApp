import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var articles = [];

    for (var i = 0; i < 10; i++) {
      articles.add(Article(
        "Hi this is the article ${i}",
        "The Hindu - B.Akash",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Orci phasellus egestas tellus rutrum tellus. Ultricies mi eget mauris pharetra et ultrices. Morbi tincidunt ornare massa eget egestas. Mauris rhoncus aenean vel elit scelerisque mauris pellentesque pulvinar. Quis enim lobortis scelerisque fermentum dui faucibus in ornare. Diam ut venenatis tellus in metus vulputate eu. Sollicitudin ac orci phasellus egestas. Facilisi nullam vehicula ipsum a. Sed elementum tempus egestas sed sed risus. Odio tempor orci dapibus ultrices in iaculis.",
      ));
    }
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
          child: ListView(
            children: articles
                .map(
                  (article) => Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 200.0,
                        maxHeight: 300.0,
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
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(0.0),
                                title: Text(
                                  article.getTitle(),
                                  style: GoogleFonts.merriweather(
                                    color: Color(0xffe91e63),
                                    textStyle: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff424242),
                                      decorationStyle: TextDecorationStyle.solid,
                                    ),
                                  ),
                                ),
                                subtitle: Text(article.getCredit(),style : GoogleFonts.lato(textStyle: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold
                                )),),
                              ),
                              Center(
                                child: ConstrainedBox(constraints : BoxConstraints(
                                  maxHeight: 150
                                ),child: Text(article.getBody(),style : GoogleFonts.lato(),)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class Article {
  String title;
  String credit;
  String body;

  Article(this.title, this.credit, this.body);

  getTitle() {
    return this.title;
  }

  getBody() {
    return this.body;
  }

  getCredit() {
    return this.credit;
  }
}
