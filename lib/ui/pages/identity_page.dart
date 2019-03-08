import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/data/user_info/user_info.dart';
import 'package:flutter_wanandroid/ui/pages/m_home_page.dart';
import 'package:flutter_wanandroid/ui/pages/m_main_page.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

class IdentityPage extends StatefulWidget {
  final List<returnValue> mData;

  IdentityPage({Key key, @required this.mData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print("IdentityPage     ${mData.toString()}");
    return _IdentityPage(mData);
  }
}

class _IdentityPage extends State<IdentityPage> {
  List<returnValue> mData;

  _IdentityPage(this.mData) : super();

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
                padding: EdgeInsets.all(18.0),
                itemExtent: 20.0,
                itemCount: mData.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: buildItem,
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

  //ListView的Item
  Widget buildItem(BuildContext context, int index) {
    //设置分割线
    if (index.isOdd) return new Divider();
    //设置字体样式
    var backgroudPaint = new Paint();
    backgroudPaint.color = Colors.amber;
    TextStyle textStyle = new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        background: backgroudPaint);
    //设置Padding
    return new GestureDetector(

        onTap: () {
          //处理点击事件
          Navigator.push(
              context,new MaterialPageRoute(builder: (context)
          =>
          new M_MainPage()
          )

          );
        },
        child: new Align(
            widthFactor: 30.0,
            heightFactor: 18.0,
            child: new Text('${mData[index].roleName}', style: textStyle)));
  }
}
