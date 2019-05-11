import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/models/EnmuModels.dart';

class MessageDetailPage extends StatefulWidget {
  MessageModel model;

  MessageDetailPage(this.model);

  @override
  _MessageDetailState createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetailPage> {
  Widget _buildHeadView(BuildContext context) {
    return new Column(
      children: <Widget>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: new MyAppBar(
        title: Text("通知详情"),
        centerTitle: true,
      ),
      body: new Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    widget.model.msgTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Gaps.hGap5,
                  new Text("时间：${widget.model.createDateApi}"),
                  Gaps.hGap10,
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "发布人：${widget.model.sendName}",
                        maxLines: 1,
                        style: TextStyle(color: Colors.blue),
                      ),
                      new Text("接收人：${widget.model.msgReceiveNames}",
                          style: TextStyle(color: Colors.blue), maxLines: 1),
                      new Text(
                          MessageType.getPushTypeString(widget.model.msgType),
                          style: TextStyle(color: Colors.blue),
                          maxLines: 1),
                    ],
                  ),
                  Gaps.hGap5,
                  new Text(widget.model.msgContent)
                ]),
            padding: EdgeInsets.only(
                left: 18.0, top: 10.0, right: 18.0, bottom: 10.0),
            color: Colors.white,
          ),
          new Expanded(child: ListView()),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "发布人：${widget.model.sendName}",
                maxLines: 1,
                style: TextStyle(color: Colors.blue),
              ),
              new Expanded(
                  child: new EditableText(
                controller: new TextEditingController(),
                style: TextStyle(color: Colors.blue),
                maxLines: 1,
                cursorColor: Colors.grey,
                backgroundCursorColor: Colors.black54,
                focusNode: FocusNode(),
              )),
              new Text(MessageType.getPushTypeString(widget.model.msgType),
                  style: TextStyle(color: Colors.blue), maxLines: 1),
            ],
          ),
        ],
      )),
    );
  }
}
