import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';

class SchoolHome_HomeItem extends StatelessWidget {
  VoidCallback mPress;
  String textBottm;

  SchoolHome_HomeItem({Key key, @required this.mPress, this.textBottm = ""})
      : assert(mPress != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Expanded(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new IconButton(
                    icon: new Image.asset(
                      Utils.getImgPath(
                          'weibosdk_navigationbar_back_highlighted'),
                      width: double.infinity,
                      fit: BoxFit.fill,
                      height: double.infinity,
                    ),
                    onPressed: mPress),
                new Text(
                  textBottm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.listTitle,
                ),
              ],
            )),

        decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new ExactAssetImage(
                  'weibosdk_navigationbar_back_highlighted'),
              fit: BoxFit.fill,
            ),
            color: Colors.white,
            border: new Border.all(width: 0.33, color: Colours.divider)),
    );
  }
}
