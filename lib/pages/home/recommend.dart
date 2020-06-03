import 'package:flutter/material.dart';
import './list.dart';

class RecommendPage extends StatefulWidget {
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> with AutomaticKeepAliveClientMixin {

  // 保存页面状态
  @override
  bool get wantKeepAlive =>true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff5f5f5),
      child: ListArea()
    );
  }
}
