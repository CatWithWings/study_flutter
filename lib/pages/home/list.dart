import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../../routers/application.dart';
import 'dart:async';

// 文字间的 · 符号
class _IndexDot extends StatelessWidget {
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

class _Title extends StatelessWidget {
  final String content;

  _Title(content)
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

class _Name extends StatelessWidget {
  final String name;
  final List tags;
  final String photo;

  _Name(name, tags, photo)
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

class _Desc extends StatelessWidget {
  final String desc;

  _Desc(String desc)
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

class _Comments extends StatelessWidget {
  final num starNum;
  final num commentNum;

  _Comments(num starNum, num commentNum)
    : starNum = starNum,
      commentNum = commentNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Text("${this.starNum}赞同"),
          _IndexDot(),
          Text("${this.commentNum}评论")
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  Map<String, dynamic> params;
  _ListItem(Map<String, dynamic> params) {
    this.params = params;
  }

  @override
  Widget build(BuildContext context) {
    final dataSource = params;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: GestureDetector(
        onTap: () {
          Application.router.navigateTo(
              context,
              '/article?articleId=${
                dataSource["id"]
              }&title=${
                Uri.encodeComponent(dataSource["title"])
              }',
              transition: TransitionType.inFromRight
          );
        },
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Title(dataSource["title"]),
            _Name(dataSource["name"], dataSource["tags"], dataSource["photo"]),
            _Desc(dataSource["desc"]),
            _Comments(dataSource["starNum"], dataSource["commentNum"])
          ],
        ),
      )
    );
  }
}

class ListArea extends StatefulWidget {
  _ListAreaState createState() => _ListAreaState();
}

class _ListAreaState extends State<ListArea> {
  List<Map<String, dynamic>> entries = [];
  num pageCount = 1;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false; // 是否有请求正在进行
  bool ifEnd = false; // 下拉列表结束标志

  @override
  void initState() {
    super.initState();

    _retrieveData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (this.pageCount <= 3) {
          this.ifEnd = false;
          setState(() {
            this.pageCount++;
          });
          _retrieveData();
        } else { // 模拟结束下拉加载标志
          setState(() {
            this.ifEnd = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff5f5f5),
      child: ListView.separated(
          itemCount: entries.length + 1, // 最后一个元素是loading或no more
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
            if (this.ifEnd == true && index == entries.length) {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
              );
            } else if (this.ifEnd != true && index == entries.length) {
              return _buildProgressIndicator();
            }

            // 模拟数据
            entries[index]["name"] = "Cat_$index";
            entries[index]["id"]=index;
            return _ListItem(entries[index]);
          },
          //分割器构造器
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 10,
              color:  Colors.black.withOpacity(0.0),
            );
          },
          controller: _scrollController
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  // 请求上线
  void _retrieveData() {
    final testData = [
      {
        "title": "卧槽！牛皮了，头一次见有大佬把TCP/IP三次握手四次挥手解释的这么明白",
        "name": "Cat001",
        "tags": ["蘑菇街", "算法工程师", "算法工程师", "算法工程师", "算法工程师", "算法工程师", "算法工程师"],
        "desc": "计算机网络结构再计算机网络的基本概念",
        "starNum": 1607,
        "commentNum": 2333,
        "area": "前端圈",
        "photo": "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg"
      },
      {
        "title": "程序员必须掌握哪些算法",
        "name": "Cat002",
        "desc": "计算机网络结构再计算机网络的基本概念",
        "starNum": 1607,
        "commentNum": 2333,
        "photo": ""
      }
    ];
    if (!this.isPerformingRequest) {
      setState(() => this.isPerformingRequest = true);

      // 模拟请求
      new Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          // 模拟数据
          if (this.pageCount < 3) {
            for(var i = 0; i < 5; i++) {
              this.entries.addAll(testData);
            }
          } else if (this.pageCount == 3) {
            for(var i = 0; i < 1; i++) {
              this.entries.addAll(testData);
            }
          }
          this.isPerformingRequest = false; // 下一个请求可以开始了
        });
      });
    }
  }
}
