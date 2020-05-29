import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../routers/routes.dart';
import '../routers/application.dart';

import './home/home.dart';
import './member/member.dart';
import './discover/discover.dart';
import './message/message.dart';
import './mine/mine.dart';


class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  _MyAppState() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  final TextStyle tabTextStyleNormal =
    TextStyle(color: const Color(0xffdddddd));
  final TextStyle tabTextStyleActive =
    TextStyle(color: const Color(0xff4d91fd));

  final Map<Widget,  Widget> pageMap = {
    Tab(
      text: '首页',
      icon: Icon(Icons.home)
     ):  HomePage(),
    Tab(
      text: '会员',
      icon: Icon(Icons.stars)
    ): MemberPage(),
    Tab(
      text: '发现',
      icon: Icon(Icons.camera)
    ): DiscoverPage(),
    Tab(
      text: '消息',
      icon: Icon(Icons.message)
    ): MessagePage(),
    Tab(
      text: '我的',
      icon: Icon(Icons.perm_identity)
    ): MinePage()
  };

  List<Tab> _bottomTabs = [];
  int currentTabIndex = 0;

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    // 获取tabs
    pageMap.forEach((key, value) {
      _bottomTabs.add(key);
    });

    _tabController = TabController(vsync: this, length: _bottomTabs.length);
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
      theme: ThemeData(primaryColor: const Color.fromRGBO(77, 145, 253, 1.0)),
      home: Scaffold(
        body: new Stack(
          children: _bottomTabs.asMap().keys.map((index) {
            return Offstage(
              offstage: index != currentTabIndex,
              child: pageMap[_bottomTabs[index]],
            );
          }).toList(),
        ),
        bottomNavigationBar: new Material(
          color: Colors.white,
          child: TabBar(
            indicator: const BoxDecoration(),
            tabs: _bottomTabs,
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Color(0xff666666),
          ),
        )
      ),
      onGenerateRoute: Application.router.generator,
    );
  }

  _onTabChange () {
    if (_tabController.indexIsChanging) {
      if (this.mounted) {
        setState(() {
          currentTabIndex = _tabController.index;
        });
        print(_tabController.index);
      }
    }
  }
}
