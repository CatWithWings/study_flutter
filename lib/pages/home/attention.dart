import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../../routers/application.dart';

class AttentionPage extends StatefulWidget {
  _AttentionPageState createState() => _AttentionPageState();
}

class _AttentionPageState extends State<AttentionPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Attention'),
          RaisedButton(
            onPressed: () {
              Application.router.navigateTo(
                context,
                '/article?articleId=${Uri.encodeComponent('123')}&title=${Uri.encodeComponent('文章标题')}',
                transition: TransitionType.inFromRight
              );
            },
            child: const Text(
                'Enabled Button',
                style: TextStyle(fontSize: 20)
            ),
          )
        ],
      )
    );
  }
}
