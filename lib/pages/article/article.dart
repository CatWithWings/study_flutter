import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  final String articleId;
  final String title;
  ArticlePage(this.articleId, this.title);

  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Container(
      child: Text('Article: ${widget.articleId}'),
    )
  );
  }
}
