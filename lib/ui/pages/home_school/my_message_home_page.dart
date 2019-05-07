import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/pages/home_school/receive_page.dart';
import 'package:flutter_wanandroid/ui/pages/main_page.dart';
import 'package:flutter_wanandroid/ui/widgets/school_home.dart';
import 'package:flutter_wanandroid/ui/pages/main_page.dart';

class _Page {
  final String labelId;
  final IconData icon;

  _Page(this.labelId, this.icon);
}

final List<_Page> _allPages = <_Page>[
  new _Page("接收的通知", null),
  new _Page('发布的通知', null),
];
enum TabsScrollableStyle { iconsAndText, iconsOnly, textOnly }

class MyMessageHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ScrollableTabsState();
  }
}

class _ScrollableTabsState extends State<MyMessageHomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  TabsScrollableStyle _scrollableStyle = TabsScrollableStyle.textOnly;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TabController(length: _allPages.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme
          .of(context)
          .canvasColor,
      appBar: new MyAppBar(
        backgroundColor: Colors.white,
        leading: new Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  Utils.getImgPath('weibosdk_navigationbar_back_highlighted'),
                ),
              )),
        ),
        centerTitle: true,
        title: new Text(
          "家校互动",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              print("点击了");
            },
            textColor: Colors.blue,
            child: Text("发布通知"),
          )
        ],
        bottom: new TabBar(
            controller: _controller,
            isScrollable: false,
            labelColor: Colors.lightBlueAccent,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red,
            indicatorPadding: EdgeInsets.only(left: 20.0, right: 20.0),
            tabs: _allPages.map((_Page page) {
              switch (_scrollableStyle) {
                case TabsScrollableStyle.iconsAndText:
                  return new Tab(text: page.labelId, icon: new Icon(page.icon));
                case TabsScrollableStyle.iconsOnly:
                  return new Tab(icon: new Icon(page.icon));
                case TabsScrollableStyle.textOnly:
                  return new Tab(text: page.labelId,);
              }
            }).toList()),
      ),
      body: new TabBarView(
        // 控件的选择和动画状态
          controller: _controller,
          // 每个标签一个控件
          children: buildChild(context)
      ),
    );
  }

  List<Widget> buildChild(BuildContext context) {
    var list = List<Widget>();
    list.add(buildReceive(context));
    list.add(buildSend(context));
    return list;
  }

  Widget buildReceive(BuildContext context) {
    return ReceivePage();
  }

  Widget buildSend(BuildContext context) {
    return ReceivePage();
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      isScrollable: true,
      labelPadding: EdgeInsets.all(12.0),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: _allPages
          .map((_Page page) =>
      new Tab(text: IntlUtil.getString(context, page.labelId)))
          .toList(),
    );
  }
}
