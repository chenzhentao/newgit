import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:flutter_wanandroid/data/user_info/user_info.dart';
import 'package:flutter_wanandroid/data/user_info/identity_info.dart';
import 'package:flutter_wanandroid/ui/pages/m_home_page.dart';
import 'package:flutter_wanandroid/ui/pages/m_main_page.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

class IdentityPage extends StatefulWidget {
  final List<LoginReturnValue> mData;

  IdentityPage({Key key, @required this.mData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _IdentityPage(mData);
  }
}

class _IdentityPage extends State<IdentityPage> {
  List<LoginReturnValue> mData;

  _IdentityPage(this.mData) : super();
  int checkedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mData.isEmpty) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('提示'),
                actions: <Widget>[
                  FlatButton(
                    child: Text("退出"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
                content: Text('错误的用户信息，请与公司联系'));
          });
    } else if (mData.length == 1) {
      var tata = mData[checkedIndex];
      /*  SpHelper.putObject<String>(
                      'identy_info',tata .toJson().toString());*/

      Map<String, String> mDataMap = {
        'mobileId': tata.mobileId.toString(),
        'baseRoleId': tata.baseRoleId.toString(),
        'roleName': tata.roleName,
        'roleId': tata.roleId.toString()
      };
      new WanRepository().getIdentityForm(mDataMap).then((onValue) {
//                    LogUtil.e(onValue .toJson());
//                    LogUtil.e(onValue.roleName);
        var valueJson = onValue .toString();
        SpHelper.putObject<String>(
            'identy_info',valueJson);
        Navigator.of(context).pop('/LoginPage');
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) => new M_MainPage()));
      });

    } else
      mData[checkedIndex].isSelected = true;
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
                shrinkWrap: true,
                itemCount: mData.length,
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                    //highlightColor: Colors.red,
                    splashColor: Colors.blueAccent,
                    onTap: () {
                      setState(() {
                        if (checkedIndex != index) {
                          mData[checkedIndex].isSelected = false;
                          mData[index].isSelected = true;
                          checkedIndex = index;
                        }
                        /*mData.forEach((element) => element.isSelected = false);
                        mData[index].isSelected = true;*/
                      });
                    },
                    child: new RadioItem(mData[index]),
                  );
                },
              ),
              RaisedButton(
                child: Text('确认'),
                onPressed: () {
                  var tata = mData[checkedIndex];
                /*  SpHelper.putObject<String>(
                      'identy_info',tata .toJson().toString());*/

                  Map<String, String> mDataMap = {
                    'mobileId': tata.mobileId.toString(),
                    'baseRoleId': tata.baseRoleId.toString(),
                    'roleName': tata.roleName,
                    'roleId': tata.roleId.toString()
                  };
                  print(mDataMap.toString());

                  new WanRepository().getIdentityForm(mDataMap).then((onValue) {
//                    LogUtil.e(onValue .toJson());
//                    LogUtil.e(onValue.roleName);
                  var valueJson = onValue .toString();
                    SpHelper.putObject<String>(
                        'identy_info',valueJson);
                  Navigator.of(context).pop('/LoginPage');
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new M_MainPage()));
                  });
                },
              )
            ],
          ),
        ));
  }
}

class RadioItem extends StatelessWidget {
  final LoginReturnValue _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin:
          new EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
      child: new Wrap(
        /* mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:MainAxisAlignment.spaceAround,*/
        children: <Widget>[
          new Container(
            height: 50.0,
            /* width: 300,*/
            child: new Center(
              child: new Text(_item.roleName,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
            ),
          ),
        ],
      ),
    );
  }
}
