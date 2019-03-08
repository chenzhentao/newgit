import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/data/user_info/user_info.dart';

class IdentityPage extends StatefulWidget {
  final List<returnValue> mData;

  IdentityPage({Key key, @required this.mData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _IdentityPage();
  }
}

class _IdentityPage extends State<IdentityPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: new Text('请选择身份'), centerTitle: true),
        body: new Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemExtent: 20.0,
                itemBuilder: (BuildContext context, int index) {
                  return Text('entry $index');
                },
              ),
              RaisedButton(
                child: Text('确认'),
                onPressed: () {
                  print('确认了');
                },
              )
            ],
          ),
        ));
  }
}
