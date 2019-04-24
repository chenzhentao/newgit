import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';

class MTitle extends StatelessWidget {

  VoidCallback mBackPress;
  String titleLeft;
  String title;
  String titleRight1;
  String titleRight2;

  MTitle({Key key,@required this.mBackPress,this.titleLeft = "",this.title= "",this.titleRight1= "",this.titleRight2= ""}):assert(mBackPress!=null),super(key:key);

  get press => mBackPress;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(icon: new Image.asset(
                      Utils.getImgPath('weibosdk_navigationbar_back_highlighted'),
                      width: double.infinity,
                      fit: BoxFit.fill,
                      height: double.infinity,
                    ), onPressed: press),
                    new Text(
                      titleLeft,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.listTitle,
                    ),
                    Gaps.vGap10,
                    new Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.listContent,
                    ),
                    Gaps.vGap5,
                    new Text(
                      titleRight1,
                      style: TextStyles.listExtra,
                    ),
                    Gaps.hGap10,
                    new Text(
                      titleRight2,
                      style: TextStyles.listExtra,
                    ),

                  ],
                )),

          ],
        ),
        decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border.all(width: 0.33, color: Colours.divider)));
  }


}