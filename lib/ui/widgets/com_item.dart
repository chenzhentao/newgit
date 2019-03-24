import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';

class ComArrowItem extends StatelessWidget {
  const ComArrowItem(this.model, {Key key}) : super(key: key);
  final ComModel model;

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
                child: new Text(model.roleName,
                    style: new TextStyle(
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                        fontSize: 18.0)),
              ),
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: new Border.all(width: 1.0, color: Colors.grey),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(5.0)),
              ),
            ),
          ]),
    );
  }
}
