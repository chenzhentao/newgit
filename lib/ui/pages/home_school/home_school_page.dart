import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
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
    return new MTitle(
      titleLeft: "",
      title: "家校互动",
      titleRight1: "",
      titleRight2: "",
      mBackPress: () {
        Navigator.of(context).pop();
      },
    );
  }
}
