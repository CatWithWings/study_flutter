import 'package:flutter/material.dart';

// 文字间的 · 符号
class IndexDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3.0,
      height: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: Color(0xFFB2BAC2),
        borderRadius: BorderRadius.all(Radius.circular(3.0))),
    );
  }
}

class Title extends StatelessWidget {
  final String content;

  Title(content)
    :content = content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Text(
              content,
              maxLines: 2,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
              ),
            ),
          )
        ),
      ],
    );
  }
}

class Name extends StatelessWidget {
  final String name;
  final List tags;
  final String photo;

  Name(name, tags, photo)
    : name = name,
      tags = tags,
      photo = photo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          this.photo == null
            ? Text('')
            : Container(
              margin: const EdgeInsets.only(right: 5),
              child: ClipOval(
                child: Image.network(
                  this.photo,
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                    return Container(
                      width: 16,
                      height: 16,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Text(
              this.name,
              style: TextStyle(
                color: Color(0xff666666),
              ),
            ),
          ),
          Expanded(
            child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                      fontSize: 12
                    ),
                    children:
                      this.tags == null
                        ? []
                        : this.tags.asMap().keys.map((index) {
                          return TextSpan(
                            text: index != this.tags.length -1
                              ? '${this.tags[index]} · '
                              : this.tags[index],
                            style: TextStyle(
                              color: Color(0xff999999)
                            )
                          );
                        }).toList()
                )
            ),
          ),
        ],
      ),
    );
  }
}

class Desc extends StatelessWidget {
  final String desc;

  Desc(String desc)
    : desc = desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        this.desc,
        style: TextStyle(color: Color(0xff666666)),
      ),
    );
  }
}

class Comments extends StatelessWidget {
  final num starNum;
  final num commentNum;

  Comments(num starNum, num commentNum)
    : starNum = starNum,
      commentNum = commentNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Text("${this.starNum}赞同"),
          IndexDot(),
          Text("${this.commentNum}评论")
        ],
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  Map<String, dynamic> params;
  ListItem(Map<String, dynamic> params) {
    this.params = params;
  }

  _ListItemState createState() => _ListItemState(this.params);
}

class _ListItemState extends State {
  Map<String, dynamic> params;
  _ListItemState(Map<String, dynamic> params) {
    this.params = params;
  }

  @override
  Widget build(BuildContext context) {
    final dataSource = params;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Title(dataSource["title"]),
          Name(dataSource["name"], dataSource["tags"], dataSource["photo"]),
          Desc(dataSource["desc"]),
          Comments(dataSource["starNum"], dataSource["commentNum"])
        ],
      ),
    );
  }
}
