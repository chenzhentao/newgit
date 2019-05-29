import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/pages/identity_page.dart';
import 'package:flutter_wanandroid/ui/pages/main_left_page.dart';
import 'package:flutter_wanandroid/ui/pages/main_page.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

class _Page {
  final String labelId;

  _Page(this.labelId);
}
final List<Icon> _allIcons = <Icon>[
  new Icon(Icons.ac_unit),
  new Icon(Icons.home),
  new Icon(Icons.backup),
  new Icon(Icons.video_label),
];

final List<_Page> _allPages = <_Page>[
  new _Page(Ids.titleHome),
  new _Page(Ids.titleRepos),
  new _Page(Ids.titleEvents),
  new _Page(Ids.titleSystem),
];

class M_MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new DefaultTabController(

        length: _allPages.length,
        child: new Scaffold(
          appBar: new MyAppBar(
            backgroundColor: Colors.white70,
            centerTitle: true,
            title: new Text('任行宝',style: TextStyle(color: Colors.black),),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.search,color: Colors.blueAccent,),
                  onPressed: () {
                    NavigatorUtil.pushPage(context, new SearchPage(),
                        pageName: "SearchPage");
                    // NavigatorUtil.pushPage(context,  new TestPage());
                    //  NavigatorUtil.pushPage(context,  new DemoApp());
                  })
            ],
          ),

          body: new TabBarViewLayout(),
          drawer: new Drawer(child: new IdentityPage(mData:SpHelper.getLoginBeanList()),
          ),
          bottomNavigationBar: new Material(color: Colors.white70,child: new TabLayout(),),
        ));
  }
}
class TabLayout extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new TabBar(
      isScrollable: false,
      labelPadding: EdgeInsets.all(0.0),
      labelColor:Colors.blueAccent,
      unselectedLabelColor:Colors.grey,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: _allPages
          .map((_Page page) =>
      new Tab(text: IntlUtil.getString(context, page.labelId),icon: _allIcons.elementAt(_allPages.indexOf(page)),))
          .toList(),
    );
  }
  }

