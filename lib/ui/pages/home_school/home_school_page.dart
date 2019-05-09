import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/pages/home_school/my_message_home_page.dart';
import 'package:flutter_wanandroid/ui/widgets/school_home.dart';
import 'package:flutter_wanandroid/ui/widgets/title.dart';

class HomeSchoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: new AppBar(
        title: new Text("家校互动"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: new Image.asset(Utils.getImgPath('carsreen'),
                width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
          ),
          buidlTtle(context),
        ],
      ),
    );
  }

  Widget buidlTtle(BuildContext context) {
    List<String> iconList =
        List.of({"jx_banji", "jx_xingxiang", "jx_tongzhi", "jx_siliao"});
    return new GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      padding: const EdgeInsets.only(
          left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
      children: <Widget>[
        new IconButton(
            icon: new Image.asset(
              Utils.getImgPath(iconList[0]),
              width: double.infinity,
              fit: BoxFit.fill,
              height: double.infinity,
            ),
            onPressed: () {   Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MyMessageHomePage()));}),
        new IconButton(
            icon: new Image.asset(
              Utils.getImgPath(iconList[1]),
              width: double.infinity,
              fit: BoxFit.fill,
              height: double.infinity,
            ),
            onPressed: () {}),
        new IconButton(
            icon: new Image.asset(
              Utils.getImgPath(iconList[2]),
              width: double.infinity,
              fit: BoxFit.fill,
              height: double.infinity,
            ),
            onPressed: () {}),
        new IconButton(
            icon: new Image.asset(
              Utils.getImgPath(iconList[3]),
              width: double.infinity,
              fit: BoxFit.fill,
              height: double.infinity,
            ),
            onPressed: () {}),
      ],
    );
  }
}
