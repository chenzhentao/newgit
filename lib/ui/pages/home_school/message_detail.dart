import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/protocol/messaget_bean_entity.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:flutter_wanandroid/models/EnmuModels.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter_wanandroid/models/message_detail_bean_entity.dart';
import 'package:flutter_wanandroid/ui/pages/demos/image_picker_demo.dart';
import 'package:flutter_wanandroid/ui/widgets/bubble_item.dart';
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

  TextEditingController _replyFieldController = new TextEditingController();

  void _getDatas() {
    mobileId = SpHelper
        .getIndentityBean()
        .mobileId;
    mUserId = SpHelper
        .getIndentityBean()
        .userVo
        .id
        .toString();
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

  bool isRecord = false;
  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    var headView = new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                      footer: new ClassicFooter(
                        noDataText: '没有更多数据',
                        noMoreIcon: Text(""),
                      ),
                      onOffsetChange: _onOffsetCallback,
                      child: ListView.builder(
                        itemCount: data.length + 1,
                        itemBuilder: _itemBuild,
                      )),
                )),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new IconButton(
                  icon:
                  Image.asset(Utils.getImgPath(isRecord ? 'yuyin' : 'jianpan')),
                  onPressed: () {
                    setState(() {
                      isRecord = !isRecord;
                    });
                  },
                ),
                new Expanded(
                  child: new TextField(
                    controller: _replyFieldController,
                    onSubmitted: (value) {
                      _replyMessage(value);
                    },
                    /*onChanged: (value) {
                  LogUtil.e("onChanged ${value}");

                  LogUtil.e(
                      "onChanged _replyFieldController${_replyFieldController.value.toString()}");
                },*/
                    maxLines: 10,
                    minLines: 1,
                    decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 8.0, top: 10.0, bottom: 6.0, right: 10.0),
                        labelText: '请输入',
                        fillColor: Colors.blue,
                        border: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                    style: TextStyle(color: Colors.black87),
                    focusNode: FocusNode(),
                  ),
                ),
                new IconButton(
                  icon: Image.asset(Utils.getImgPath('bj_fabu_tupian')),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new IamgePickerPage());
                    /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new IamgePickerPage(title:"选择图片"),
                ),
              );*/
                  },
                ),
                new Padding(
                    padding: EdgeInsets.only(right: 6.0),
                    child: new Theme(
                      data: Theme.of(context).copyWith(
                          buttonTheme: ButtonThemeData(
                              minWidth: 40.0,
                              height: 5,
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  top: 0.0,
                                  right: 10.0,
                                  bottom: 0.0))),
                      child: new RaisedButton(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 2, bottom: 2.0, right: 10.0),
                        onPressed: () {
                          _replyMessage(_replyFieldController.text);
                        },
                        color: Colors.blueAccent,
                        child: Text(
                          "提交",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(8.0))),
                      ),
                    )),
              ],
            ),
          ],
        ));
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .canvasColor,
      appBar: new MyAppBar(
        title: Text("通知详情"),
        centerTitle: true,
      ),
      body: headView,
    );
  }

  void _replyMessage(String content) {
    LogUtil.e(content);
    LogUtil.e(content);
    LogUtil.e(content);
    LogUtil.e(content);
    LogUtil.e(content);
    LogUtil.e(content);
    LogUtil.e(content);
    LogUtil.e(content);
    LogUtil.e(content);
    Map<String, String> dataMap = {
      'content': content,
      'userId': mUserId,
      'messageId': widget.model.messageId.toString()
    };
    String ownerMobileUserId = widget.model.ownerMobileUserId.toString();
    if (ownerMobileUserId != null) {
      /* dataMap.putIfAbsent("ownerMobileUserId", () {
        return ownerMobileUserId;
      });*/
    }
    LogUtil.e(dataMap.toString());
    wanRepository.replayMessages(dataMap).then((list) {
      if (mounted)
        setState(() {
          _onLoading(true);
        });
    });
  }

  Widget _itemBuild(context, index) =>
      (index == 0) ? buildSwiper(context) : Item(mobileId, data[index - 1]);

  WanRepository wanRepository = new WanRepository();

  void _onLoading(bool isRefresh) {
    if (isRefresh || mDataPage < 0) {
      mDataPage = 0;
    } else {
      mDataPage++;
    }
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
          if (list == null || list.listVo == null) {
            mDataPage--;
            _refreshController.refreshFailed();
            return;
          }
          if (list.listVo.length <= 0) {
            mDataPage--;
            _refreshController.loadNoData();
            return;
          }
          data.addAll(list.listVo);
          if (!isRefresh) {
            _refreshController.resetNoData();
            _refreshController.loadComplete();
          } else {
            _refreshController.refreshCompleted();
          }
        });
    });
  }

  Widget buildSwiper(BuildContext context) {
    return new Container(
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
            Gaps.vGap5,
            new Text("时间：${widget.model.createDateApi}"),
            Gaps.vGap10,
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
                        style: TextStyle(color: Colors.blue), maxLines: 1)),
                new Text(MessageType.getPushTypeString(widget.model.msgType),
                    style: TextStyle(color: Colors.blue), maxLines: 1),
              ],
            ),
            SizedBox(
                height: 10.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: new Border(
                          bottom: new BorderSide(
                              width: 0.33, color: Colours.divider))),
                )),
            Gaps.vGap5,
            new Container(
                padding: new EdgeInsets.only(right: 13.0),
                child: new Text(
                  widget.model.msgContent,
//                  maxLines: 50,
                ))
          ]),
      padding:
      EdgeInsets.only(left: 18.0, top: 10.0, right: 18.0, bottom: 10.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(width: 0.33, color: Colours.divider)),
    );
  }

  PopupMenuButton showChiocePopwin(BuildContext context) {
    return PopupMenuButton(itemBuilder: _popMenuItemBuild);
  }

  List<String> _imageOptions = ['相册', "相机", '选择视频', '录视频'];

  List<PopupMenuEntry> _popMenuItemBuild(BuildContext context) {
    return List.generate(_imageOptions.length, (index) {
      new RaisedButton(onPressed: () {}, child: Text(_imageOptions[index]),);
    }).toList();
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
    if (widget.userId != itemData.userId) //我发的,在右边
      return Container(
          alignment: Alignment.topRight,
          color: Colors.grey.withAlpha(5),
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(
            children: <Widget>[
              Text(
                '${itemData.createDate}',
                style: TextStyle(color: Colors.black54),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                      child: new Container(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '${itemData.userName}',
                                  textAlign: TextAlign.end,
                                  style:
                                  TextStyle(
                                      fontSize: 12.0, color: Colors.black54),
                                ),
                              ),
                              Gaps.vGap10,
                              new Container(
                                  padding: EdgeInsets.only(
                                      left: 7.0,
                                      top: 9.0,
                                      right: 22.0,
                                      bottom: 5.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          Utils.getImgPath('qipao_you')),
                                      centerSlice:
                                      new Rect.fromLTRB(7.0, 45.0, 30.0, 51.0),
                                    ),
                                  ),
                                  child: Text(
                                    '${itemData
                                        .content}拉尔来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 10,
                                  ))
                            ],
                          ))),
                  Image.network(
                    "http://126306.sgss8.com/upload/2016042923/232418_1381.jpg",
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ));
    else {
      //对方发的,在左边
      return Container(
          color: Colors.grey.withAlpha(5),
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(
            children: <Widget>[
              Text(
                '${itemData.createDate}',
                style: TextStyle(color: Colors.black54),
              ),
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
                      child: new Container(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '${itemData.userName}',
                                  textAlign: TextAlign.start,
                                  style:
                                  TextStyle(
                                      fontSize: 12.0, color: Colors.black54),
                                ),
                              ),
                              Gaps.vGap10,
                              new Container(
                                  padding: EdgeInsets.only(
                                      left: 27.0,
                                      top: 9.0,
                                      right: 8.0,
                                      bottom: 5.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          Utils.getImgPath('qipao_zuo')),
                                      centerSlice:
                                      new Rect.fromLTRB(27.0, 45.0, 57.0, 51.0),
                                    ),
                                  ),
                                  child: Text(
                                    '${itemData
                                        .content}拉尔来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年来访成行横欧文这等拉结你了今年',
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
