import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/protocol/messaget_bean_entity.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:flutter_wanandroid/models/EnmuModels.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter_wanandroid/models/message_detail_bean_entity.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/ui/pages/demos/image_picker_demo.dart';
import 'package:flutter_wanandroid/ui/pages/demos/sound_demo.dart';
import 'package:flutter_wanandroid/ui/pages/demos/video_demo.dart';
import 'package:flutter_wanandroid/ui/widgets/audio_record_button.dart';
import 'package:flutter_wanandroid/ui/widgets/bubble_item.dart';
import 'package:flutter_wanandroid/ui/widgets/message_detail_item.dart';
import 'package:http_parser/http_parser.dart';
import 'package:video_player/video_player.dart';

class MessageDetailPage extends StatefulWidget {
  final MessagetBeanReturnvalueListvo model;

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

  get _result => (result, audioLength) {
        _replyAudioMessage(result, audioLength);
      };

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

  @override
  void dispose() {
    if (flutterSound.isPlaying) flutterSound.stopPlayer();

    super.dispose();
  }

  void _onOffsetCallback(bool isUp, double offset) {}
  FlutterSound flutterSound;

  bool _isPlaying = false;
  StreamSubscription _playerSubscription;

  @override
  void initState() {
    _getDatas();
    _scrollController = ScrollController(keepScrollOffset: true);
    _refreshController = RefreshController();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);

    SchedulerBinding.instance.addPostFrameCallback((_) {
//      _refreshController.requestRefresh(true);
    });
    super.initState();
  }

  bool isRecord = false;
  bool _autovalidate = false;

  void startPlayer(String videoPath) async {
    String path = await flutterSound.startPlayer(videoPath);
    await flutterSound.setVolume(1.0);

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          print(
              'startPlayer: ${e.runtimeType}   ${e.currentPosition}   ${e.duration}');
//          slider_current_position = e.currentPosition;
//          max_duration = e.duration;
//
//          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//              e.currentPosition.toInt(),
//              isUtc: true);
//          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          this.setState(() {
            this._isPlaying = true;
//            this._playerTxt = txt.substring(0, 8);
          });
        }
      });
    } catch (err) {
      print('error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    var headView = new Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
            child: Container(
          color: Colors.grey,
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
              child: new Stack(
                children: <Widget>[
                  new Offstage(
                    offstage: isRecord,
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
                  new Offstage(
                    offstage: !isRecord,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(21),
                          border: Border.all(
                        color: Colors.blueAccent,
                      )),
                      height: 36.0,
                      child:  new AudioRecordButton(_result)),

                  ),
                ],
              ),
            ),
            new IconButton(
              icon: Image.asset(Utils.getImgPath('bj_fabu_tupian')),
              onPressed: () async {
                LocalMediaType result =
                    await Navigator.push(context, new ImagePickerPage());
                print(
                    '${result.mimeType}${result.filePath}${result.width}${result.height}');
                _replyImageMessage(result);
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
                              left: 10.0, top: 0.0, right: 10.0, bottom: 0.0))),
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
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  ),
                )),
          ],
        ),
      ],
    ));
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: new MyAppBar(
        title: Text("通知详情"),
        centerTitle: true,
      ),
      body: headView,
    );
  }

/*   String guessMimeType(String path) {
    FileNameMap fileNameMap = URLConnection.getFileNameMap();
    String tempPath = path.replaceAll("-","");
    String contentTypeFor = fileNameMap.getContentTypeFor(tempPath);
    if (contentTypeFor == null) {
      contentTypeFor = "application/octet-stream";
    }
    return contentTypeFor;
  }*/
  void _replyAudioMessage(String imageResult, int length) {
    Map<String, dynamic> dataMap = {
//      'content': imagePath,
      'userId': mUserId,
      'messageId': widget.model.messageId.toString(),
    };

    if (imageResult != null && length > 0) {
      dataMap.putIfAbsent('musicTime', () {
        return "${length}";
      });

      dataMap.putIfAbsent('music', () {
        return new UploadFileInfo(new File(imageResult),
            imageResult.substring(imageResult.lastIndexOf("/") + 1),
            contentType: ContentType.parse(new MediaType('music',
                    imageResult.substring(imageResult.lastIndexOf(".") + 1))
                .mimeType));
      });
    }

    FormData formData = new FormData.from(dataMap);
    var dialog = showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: '请等待...',
          );
        });
    wanRepository.replayMessages(formData).then((list) {
      Navigator.pop(context);

      if (mounted)
        setState(() {
          _onLoading(true);
        });
    });
  }

  void _replyImageMessage(LocalMediaType imageResult) {
    Map<String, dynamic> dataMap = {
//      'content': imagePath,
      'userId': mUserId,
      'messageId': widget.model.messageId.toString(),
    };

    if (imageResult.mimeType == 1) {
      String imagePath = imageResult.filePath;
      dataMap.putIfAbsent('photo', () {
        return new UploadFileInfo(new File(imagePath),
            imagePath.substring(imagePath.lastIndexOf("/") + 1),
            contentType:
                ContentType.parse(new MediaType('image', 'jpeg').mimeType));
      });
    } else if (imageResult.mimeType == 2) {
      String imagePath = imageResult.filePath;

      print(
          "${imagePath.substring(imagePath.lastIndexOf("/") + 1)} ${imagePath.substring(imagePath.lastIndexOf(".") + 1)}             ");
      dataMap.putIfAbsent('video', () {
        return new UploadFileInfo(new File(imagePath),
            imagePath.substring(imagePath.lastIndexOf("/") + 1),
            contentType: ContentType.parse(new MediaType('audio',
                    imagePath.substring(imagePath.lastIndexOf(".") + 1))
                .mimeType));
      });
    }

    FormData formData = new FormData.from(dataMap);

    String ownerMobileUserId = widget.model.ownerMobileUserId.toString();
    var dialog = showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: '请等待...',
          );
        });
    wanRepository.replayMessages(formData).then((list) {
      Navigator.pop(context);
      if (mounted)
        setState(() {
          _onLoading(true);
        });
    });
  }

  void _replyMessage(String content) {
    LogUtil.e(content);
    Map<String, String> dataMap = {
      'content': content,
      'userId': mobileId.toString(),
      'messageId': widget.model.messageId.toString()
    };
    String ownerMobileUserId = widget.model.ownerMobileUserId.toString();
    if (ownerMobileUserId != null) {
      /* dataMap.putIfAbsent("ownerMobileUserId", () {
        return ownerMobileUserId;
      });*/
    }
    var dialog = showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: '请等待...',
          );
        });
    wanRepository.replayMessages(dataMap).then((list) {
      Navigator.pop(context);
      if (mounted)
        setState(() {
          _replyFieldController.clear();
          _onLoading(true);
        });
    });
  }

  Widget _itemBuild(context, index) => (index == 0)
      ? buildSwiper(context)
      : Item(mobileId.toString(), data[index - 1], flutterSound);

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
      'userId': mUserId.toString(),
      'messageId': widget.model.messageId.toString()
    };
    String ownerMobileUserId = widget.model.ownerMobileUserId.toString();
    if (ownerMobileUserId != null) {
      dataMap.putIfAbsent("ownerMobileUserId", () {
        return ownerMobileUserId;
      });
    }
    /* var dialog = showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: '请等待...',.
          );
        });*/
    wanRepository.getMessageDetail(dataMap).then((list) {
//      Navigator.pop(context);
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
            _refreshController.loadComplete();
          } else {
            _refreshController.resetNoData();
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
      new RaisedButton(
        onPressed: () {},
        child: Text(_imageOptions[index]),
      );
    }).toList();
  }
}

class LocalMediaType {
  final int mimeType;
  final String filePath;
  int width;
  int height;
  int duration;

  LocalMediaType(this.mimeType, this.filePath,
      {this.width, this.height, this.duration});
}

class Item extends StatefulWidget {
  final MessageDetailBeanReturnvalueListvo itemData;
  final String userId;
  final FlutterSound flutterSound;

  Item(this.userId, this.itemData, this.flutterSound);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> with TickerProviderStateMixin {
  VideoPlayerController _butterflyController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<void> connectedCompleter = Completer<void>();
  bool isSupported = true;
  bool isDisposed = false;

  StreamSubscription _playerSubscription;
  var leftSoundNames = [
    'assets/images/sound_left_0.png',
    'assets/images/sound_left_1.png',
    'assets/images/sound_left_2.png' /*,
    'assets/images/sound_left_3.png'*/
  ];
  var rightSoundNames = [
    'assets/images/sound_right_0.png',
    'assets/images/sound_right_1.png',
    'assets/images/sound_right_2.png' /*,
    'assets/images/sound_right_3.png'*/
  ];
  int _animationPosition = 3;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    //控制语音动画
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = IntTween(begin: 0, end: 3).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    if (widget.itemData.videoUrl != null) {
      Future<void> initController(
          VideoPlayerController controller, String name) async {
        controller.setLooping(false);
        controller.setVolume(0.0);
        controller.pause();
        await connectedCompleter.future;
        await controller.initialize();
        if (mounted) {
          setState(() {});
        }
      }

      _butterflyController =
          VideoPlayerController.network(widget.itemData.videoUrl);
      initController(_butterflyController, 'butterfly');
      isIOSSimulator().then<void>((bool result) {
        isSupported = !result;
      });
    }
  }

  void startPlayer(String videoPath) async {
    controller.forward();
    if (widget.flutterSound.isPlaying) {
      widget.flutterSound.stopPlayer();
    }
    String path = await widget.flutterSound.startPlayer(videoPath);
    await widget.flutterSound.setVolume(1.0);

    try {
      _playerSubscription =
          widget.flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          if (e.duration <= e.currentPosition) {
            controller.reset();
          }
          print(
              'startPlayer: ${e.currentPosition}     ${e.duration}      ${e.runtimeType}');
//          slider_current_position = ;
//          max_duration = ;
//
//          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//              e.currentPosition.toInt(),
//              isUtc: true);
//          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          if (mounted)
            this.setState(() {
//            this._isPlaying = true;
//            this._playerTxt = txt.substring(0, 8);
            });
        }
      });
    } catch (err) {
      print('error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    var itemData = widget.itemData;
//    print("${itemData.musicTime}    ${itemData.musicTime}");
    int _offstate_status = itemData.musicUrl != null && 0 < itemData.musicTime
        ? 3
        : (itemData.photoUrl != null ? 1 : (itemData.videoUrl != null ? 2 : 0));

    if (widget.userId.compareTo(itemData.userId.toString()) != 0) //我发的,在右边

      return Container(
          alignment: Alignment.topRight,
          color: Colors.grey.withAlpha(245),
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
                          padding: EdgeInsets.only(left: 37.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '${itemData.userName == null ? "匿名用户" : itemData.userName}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black54),
                                ),
                              ),
                              Gaps.vGap10,
                              new Stack(
                                children: <Widget>[
                                  new Offstage(
                                    offstage: _offstate_status != 0,
                                    child: new Container(
                                        padding: EdgeInsets.only(
                                            left: 7.0,
                                            top: 9.0,
                                            right: 22.0,
                                            bottom: 5.0),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                Utils.getImgPath('qipao_you')),
                                            centerSlice: new Rect.fromLTRB(
                                                4.0, 20.0, 5.0, 20.5),
                                          ),
                                        ),
                                        child: Text(
                                          '${itemData.content}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                          maxLines: 10,
                                        )),
                                  ),
                                  new Offstage(
                                      offstage: _offstate_status != 1,
                                      child: new Container(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: new ConstrainedBox(
                                          constraints: new BoxConstraints(
                                              maxHeight: 200),
                                          child: new CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: itemData.photoUrl == null
                                                ? "http://126306.sgss8.com/upload/2016042923/232418_1381.jpg"
                                                : itemData.photoUrl,
                                            placeholder: new ProgressView(),
                                            errorWidget: new Icon(Icons.error),
                                          ),
                                        ),
                                      )),
                                  new Offstage(
                                    offstage: _offstate_status != 2,
                                    child: new Container(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: isSupported &&
                                              _butterflyController != null
                                          ? ConnectivityOverlay(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: SingleVideoCard(
                                                  controller:
                                                      _butterflyController,
                                                  firstScreen: widget
                                                      .itemData.firstVideoUrl,
                                                ),
                                              ),
                                              connectedCompleter:
                                                  connectedCompleter,
                                              scaffoldKey: scaffoldKey,
                                            )
                                          : const Center(
                                              child: Text(
                                                'Video playback not supported on the iOS Simulator.',
                                              ),
                                            ),
                                    ),
                                  ),
                                  new Offstage(
                                    offstage: _offstate_status != 3,
                                    child: new Container(
                                        width: itemData.musicTime != null &&
                                                60 > itemData.musicTime
                                            ? ((MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100) /
                                                60.0 *
                                                (itemData.musicTime < 30
                                                    ? 30
                                                    : itemData.musicTime))
                                            : (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100),
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: RaisedButton(
                                          padding: EdgeInsets.only(
                                              left: 8.0, right: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "${itemData.musicTime}\"",
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Image.asset(rightSoundNames[
                                                  animation.value % 3])
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18)),
                                          color: Colors.blueAccent,
                                          onPressed: () {
                                            startPlayer(itemData.musicUrl);
                                          },
                                        )),
                                  ),
                                ],
                              )
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
                          padding: EdgeInsets.only(right: 38.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '${itemData.userName == null ? "匿名用户" : itemData.userName}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black54),
                                ),
                              ),
                              Gaps.vGap10,
                              new Stack(
                                children: <Widget>[
                                  new Offstage(
                                    offstage: _offstate_status != 0,
                                    child: new Container(
                                        padding: EdgeInsets.only(
                                            left: 27.0,
                                            top: 9.0,
                                            right: 8.0,
                                            bottom: 5.0),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                Utils.getImgPath('qipao_zuo')),
                                            centerSlice: new Rect.fromLTRB(
                                                31.0, 24.0, 32.0, 25.0),
                                          ),
                                        ),
                                        child: Text(
                                          '${itemData.content}拉年拉年拉年拉年拉年拉年拉年拉年拉年拉年拉年拉年拉年',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                          maxLines: 10,
                                        )),
                                  ),
                                  new Offstage(
                                    offstage: _offstate_status != 1,
                                    child: new Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: new ConstrainedBox(
                                        constraints:
                                            new BoxConstraints(maxHeight: 200),
                                        child: new CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: itemData.photoUrl == null
                                              ? "http://126306.sgss8.com/upload/2016042923/232418_1381.jpg"
                                              : itemData.photoUrl,
                                          placeholder: new ProgressView(),
                                          errorWidget: new Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Offstage(
                                    offstage: _offstate_status != 2,
                                    child: isSupported &&
                                            _butterflyController != null
                                        ? ConnectivityOverlay(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: SingleVideoCard(
                                                controller:
                                                    _butterflyController,
                                                firstScreen: widget
                                                    .itemData.firstVideoUrl,
                                              ),
                                            ),
                                            connectedCompleter:
                                                connectedCompleter,
                                            scaffoldKey: scaffoldKey,
                                          )
                                        : const Center(
                                            child: Text(
                                              'Video playback not supported on the iOS Simulator.',
                                            ),
                                          ),
                                  ),
                                  new Offstage(
                                    offstage: _offstate_status != 3,
                                    child: new Container(
                                        width: itemData.musicTime != null &&
                                                60 > itemData.musicTime
                                            ? ((MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100) /
                                                60.0 *
                                                (itemData.musicTime < 30
                                                    ? 30
                                                    : itemData.musicTime))
                                            : (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100),
                                        height: 30,
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: RaisedButton(
                                          padding: EdgeInsets.only(
                                              left: 4.0, right: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Image.asset(leftSoundNames[
                                                  animation.value % 3]),
                                              Text(
                                                "${itemData.musicTime}\"",
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: Colors.blueAccent,
                                          onPressed: () {
                                            startPlayer(itemData.musicUrl);
                                          },
                                        )),
                                  ),
                                ],
                              )
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
    print('> VideoDemo dispose');
    isDisposed = true;
    if (_butterflyController != null) _butterflyController.dispose();

    print('< VideoDemo dispose');
    super.dispose();
  }
}
