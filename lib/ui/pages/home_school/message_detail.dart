import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/protocol/messaget_bean_entity.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:flutter_wanandroid/models/EnmuModels.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter_wanandroid/models/message_detail_bean_entity.dart';
import 'package:flutter_wanandroid/ui/widgets/message_detail_item.dart';

class MessageDetailPage extends StatefulWidget {
  MessagetBeanReturnvalueListvo model;

  MessageDetailPage(this.model);

  @override
  _MessageDetailState createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetailPage> {
  RefreshController _refreshController;
  ScrollController _scrollController;
  List<MessageDetailBeanReturnvalueListvo> data = [];
  int mobileId;

  String mUserId;
  int mDataPage = 0;

  void _getDatas() {
    mobileId = SpHelper.getIndentityBean().mobileId;
    mUserId = SpHelper.getIndentityBean().userVo.id.toString();
    _onLoading(true);
  }

  void scrollTop() {
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void enterRefresh() {
    _refreshController.requestRefresh();
  }

  void _onOffsetCallback(bool isUp, double offset) {}

  @override
  void initState() {
    _getDatas();
    _scrollController = ScrollController(keepScrollOffset: true);
    _refreshController = RefreshController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
//      _refreshController.requestRefresh(true);
    });
    super.initState();
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
                      new Expanded(
                          child: new Text(
                        "发布人：${widget.model.sendName}",
                        maxLines: 1,
                        style: TextStyle(color: Colors.blue),
                      )),
                      new Expanded(
                          child: new Text("接收人：${widget.model.msgReceiveNames}",
                              style: TextStyle(color: Colors.blue),
                              maxLines: 1)),
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
          new Expanded(
              child: Container(
            child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                isNestWrapped: true,
                header: ClassicHeader(
                  idleIcon: Container(),
                  idleText: "Load more...",
                ),
                enablePullUp: true,
                onRefresh: () {
                  _onLoading(true);
                },
                onLoading: () {
                  _onLoading(false);
                },
                onOffsetChange: _onOffsetCallback,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => Item(mobileId, data[index]),
                )),
          )),
          new Row(
            children: <Widget>[
              new IconButton(
                icon: Icon(
                  Icons.record_voice_over,
                  color: Colors.blue,
                ),
                onPressed: () {},
              ),
              new Expanded(
                  child: new TextField(
                decoration: new InputDecoration(
                    fillColor: Colors.blue,
                    border: new OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    focusedBorder: new OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
                controller: new TextEditingController(),
                style: TextStyle(color: Colors.black87),
                maxLines: 1,
                focusNode: FocusNode(),
              )),
              new IconButton(
                icon: Icon(
                  Icons.picture_in_picture_alt,
                  color: Colors.blue,
                ),
                onPressed: () {},
              ),
              new RaisedButton(
                onPressed: () {},
                child: Text("提交"),
              ),
            ],
          ),
        ],
      )),
    );
  }

  WanRepository wanRepository = new WanRepository();

  void _onLoading(bool isRefresh) {
    Map<String, String> dataMap = {
      'page': mDataPage.toString(),
      'mobileId': mobileId.toString(),
      'userId': mUserId,
      'messageId': widget.model.messageId.toString()
    };
    String ownerMobileUserId = widget.model.ownerMobileUserId.toString();
    if (ownerMobileUserId != null) {
      dataMap.putIfAbsent("ownerMobileUserId", () {
        return ownerMobileUserId;
      });
    }
    wanRepository.getMessageDetail(dataMap).then((list) {
      if (mounted)
        setState(() {
          if (mDataPage == 0) {
            data.clear();
          }
          data.addAll(list.listVo);
          if (!isRefresh)
            _refreshController.loadComplete();
          else {
            _refreshController.refreshCompleted();
          }
        });
    });
  }
}

class Item extends StatefulWidget {
  MessageDetailBeanReturnvalueListvo itemData;
  int userId;

  Item(this.userId, this.itemData);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    var itemData = widget.itemData;
    if (widget.userId == itemData.userId) //我发的,在右边
      return Card(
        color: Colors.red,
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Container(
            child: Column(
          children: <Widget>[
            Text('Data ${itemData.createDate}'),
            new Row(
              children: <Widget>[
                Image.network(
                  "http://126306.sgss8.com/upload/2016042923/232418_1381.jpg",
                  width: 25.0,
                  height: 25.0,
                ),
                new Column(
                  children: <Widget>[
                    Text('Data ${itemData.userName}'),
                    new Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Utils.getImgPath('qipao_you1')),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${itemData.content}',
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        )),
      );
    else {
      //对方发的,在左边
      return Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              Text('${itemData.createDate}',style: TextStyle(color: Colors.black54),),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    "http://126306.sgss8.com/upload/2016042923/232418_1381.jpg",
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                  new Expanded(
                    child:   new Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${itemData.userName}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.black54),
                          ),
                          Gaps.hGap10,
                          new Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          Utils.getImgPath('images_zuo')),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Text(
                                    '${itemData.content}拉尔来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 10,
                                  ))
                        ],
                      ))),
                ],
              ),
            ],
          ));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
