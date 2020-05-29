import 'package:flutter/material.dart';

import './attention.dart';
import './recommend.dart';
import './hot.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final List<Tab> _topTabs = <Tab>[
    Tab(
        text: '关注',
    ),
    Tab(
        text: '推荐',
    ),
    Tab(
        text: '热门',
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _topTabs.length);
    _tabController.addListener(() => _onTabChange());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: Scaffold(
          appBar: new AppBar(
            title: const Text(
                'Title',
                style: TextStyle(color: Color(0xff333333))
            ),
            backgroundColor: Colors.white,
            bottom: new TabBar(
              controller: _tabController,
              tabs: _topTabs,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Color(0xff666666),
              indicatorColor:Theme.of(context).primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: 16.0),
            ),
          ),
          body: new TabBarView(
            // TabBarView 默认支持手势滑动
            // 若要禁止设置 physics: NeverScrollableScrollPhysics
            controller: _tabController,
            children: <Widget>[
              AttentionPage(),
              RecommendPage(),
              HotPage(),
            ]
          ),
        )
    );
  }

  _onTabChange() {}
}
