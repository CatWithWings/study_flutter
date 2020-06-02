import 'package:flutter/material.dart';
import 'dart:async';
import './list.dart';

class RecommendPage extends StatefulWidget {
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> entries = [];
  num pageCount = 1;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false; // 是否有请求正在进行
  bool ifEnd = false; // 下拉列表结束标志

  // 保存页面状态
  @override
  bool get wantKeepAlive =>true;

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
        } else {
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

          entries[index]["name"] = "Cat_$index";
          return ListItem(entries[index]);
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
      new Timer(const Duration(milliseconds: 1000), () {
        setState(() {
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
