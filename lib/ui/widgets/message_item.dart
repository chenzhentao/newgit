import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/protocol/messaget_bean_entity.dart';
import 'package:flutter_wanandroid/models/EnmuModels.dart';
import 'package:flutter_wanandroid/ui/pages/home_school/message_detail.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(this.model, {Key key, this.isHome}) : super(key: key);

  final MessagetBeanReturnvalueListvo model;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        // new GestureDetector(
        //        onTap: () {
        print(" 跳到详情");
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new MessageDetailPage(model),
          ),
        );
        //        },
        //        ,
        //      )child:
      },
      child: new Container(
          padding: EdgeInsets.all(16.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          model.msgTitle != null
                              ? "${model.msgTitle}${model.msgTitle}${model.msgTitle}${model.msgTitle}${model.msgTitle}${model.msgTitle}"
                              : "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.listTitle,
                        ),
                      ),
                      new Expanded(
                          child: new Text(isHome?
                        "发布人：${model.sendName}":"接收对象:${model.msgReceiveNames}",
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.listExtra,
                      )),
                    ],
                  ),
                  Gaps.vGap10,
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          model.msgContent != null
                              ? "${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}"
                                  "${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}"
                                  "${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}"
                                  "${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}"
                                  "${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}${model.msgContent}"
                              : "",
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.listContent,
                        ),
                      ),
                      Container(
                        child: Theme(
                            data: Theme.of(context).copyWith(
                                buttonTheme: ButtonThemeData(
                                    minWidth: 40.0,
                                    height: 5,
                                    padding: EdgeInsets.only(
                                        left: 8.0,
                                        top: 2.0,
                                        right: 8.0,
                                        bottom: 2.0))),
                            child: new RaisedButton(
                              padding:EdgeInsets.only(
                                  left: 8.0,
                                  top: 2.0,
                                  right: 8.0,
                                  bottom: 2.0) ,
                                onPressed: () {},
                                child: Text(
                                  "${model.hasRead == 0 ? "已读" : "未读"}",
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white),
                                ),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0))),color:  model.hasRead == 0
                                ? Colors.purpleAccent
                                : Colors.red,)),
                      ),
                    ],
                  ),
                  Gaps.vGap5,
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text(
                            "类型：${PushType.getPushTypeString(model.msgScopeType)}",
                            style: TextStyles.listExtra,
                          ),
                          Gaps.hGap10,
                          new Text(
                            "范围：${MessageType.getPushTypeString(model.msgType)}",
                            style: TextStyles.listExtra,
                          ),
                        ],
                      ),
                      new Text(
                        "${model.createDateApi}",

                        style: TextStyles.listExtra,
                      ),
                    ],
                  ),
                  Gaps.vGap5,
                  new Row(
                    children: <Widget>[
                      new Icon(
                        Icons.message,
                        size: 12.0,
                        color: Colours.text_gray,
                      ),
                      Gaps.hGap5,
                      new Text(
                        "${model.commentCount!=null?model.commentCount:0}",
                        style: TextStyles.listExtra,
                      ),
                      Gaps.hGap10,
                      new Icon(
                        Icons.visibility,
                        size: 12.0,
                        color: Colours.text_gray,
                      ),
                      Gaps.hGap5,
                      new Text(
                        "${model.readCount!=null?model.readCount:0}",
                        style: TextStyles.listExtra,
                      ),
                    ],
                  ),
                ],
              )),
              /* new Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 12.0),
                child: new CircleAvatar(
                  radius: 28.0,
                  backgroundColor: Colors.grey,
                  child: new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Text(
                      "发布人：${model.msgReceiveNames}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 11.0),
                    ),
                  ),
                ),
              )*/
            ],
          ),
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(width: 0.33, color: Colours.divider))),
    );
  }
}
