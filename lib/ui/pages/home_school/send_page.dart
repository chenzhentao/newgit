import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/protocol/messaget_bean_entity.dart';
import 'package:flutter_wanandroid/data/user_info/identity_info.dart';
import 'package:flutter_wanandroid/ui/pages/home_school/message_bloc.dart';
import 'package:flutter_wanandroid/ui/pages/home_school/message_detail.dart';
import 'package:flutter_wanandroid/ui/pages/home_school/radio_group.dart';
import 'package:flutter_wanandroid/ui/widgets/message_item.dart';
import 'package:flutter_wanandroid/utils/date_format_base.dart';
import 'package:flutter_wanandroid/utils/util_index.dart';

bool sendPageInit = true;
enum ReadStatus { WeiDu, YiDu, All, School, Sys }

class SendPage extends StatefulWidget {
  const SendPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _sendPageButton();
  }
}

class _sendPageButton extends State<SendPage> {
  int _currentIndex = 1;
  String userId;
  String crDate = "2019-03";
  String readStatus = ReadStatus.All.index.toString();
  String dataType = "1";
  final IdentityBean mData = SpHelper.getIndentityBean();

  final String labelId = Ids.sendMessageId;
  List<GroupModel> _group = [
    GroupModel(
      text: "全部通知",
      index: 1,
    ),
    GroupModel(
      text: "老师通知",
      index: 2,
    ),
    GroupModel(
      text: "学校通知",
      index: 3,
    ),
    GroupModel(
      text: "家长通知",
      index: 4,
    ),
  ];

  String getStatus(int index) {
    ReadStatus.values.forEach((f) {
      if (f.index == index) return f.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    userId = mData.mobileId.toString();
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.sendMessageStream.listen((event) {
      /*if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }*/
    });

    if (sendPageInit) {
      LogUtil.e("HomePage init......");
      sendPageInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(
            labelId: labelId,
            userId: userId,
            crDate: crDate,
            readStatus: readStatus,
            dataType: dataType);
      });
    }

    var _totalPage = 0;
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: ScreenUtil.getInstance().screenWidth,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _group
                .map(
                  (item) => Container(
                        width: ScreenUtil.getInstance().screenWidth / 4 - 8,
                        margin: EdgeInsets.only(
                            left: 4.0, right: 4.0, top: 5.0, bottom: 5.0),
                        child: OutlineButton(
                          padding: EdgeInsets.all(0.0),
                          child: Text(
                            "${item.text}",
                            style: TextStyle(
                                color: item.index == _currentIndex
                                    ? Colors.white70
                                    : Colors.blue),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentIndex = item.index;
                              readStatus = _currentIndex.toString();
                              bloc.onRefresh(
                                  labelId: labelId,
                                  userId: userId,
                                  crDate: crDate,
                                  readStatus: readStatus,
                                  dataType: dataType);
                            });
                          },
                          color: item.index == _currentIndex
                            ? Colors.blue
                            : Colors.white10,

                          borderSide: BorderSide(color: Colors.blueAccent),
                          shape: new RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),),
                        ),

                      ),
                )
                .toList(),
          ),
        ),
        new Expanded(
          child: new StreamBuilder(
              stream: bloc.sendMessageStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MessagetBeanReturnvalueListvo>> snapshot) {
                return new RefreshScaffold(
                  labelId: labelId,
                  isLoading: snapshot.data == null,
                  controller: _controller,
                  enablePullUp: false,
                  onRefresh: () {
                    return bloc.onRefresh(
                        labelId: labelId,
                        userId: userId,
                        crDate: crDate,
                        readStatus: readStatus,
                        dataType: dataType);
                  },
                  child: new ListView(
                    shrinkWrap: false,
                    children: <Widget>[
                      new Container(
                        height: 40,
                        padding: EdgeInsets.only(right: 10.0),
                        width: ScreenUtil.getInstance().screenWidth,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new FlatButton(
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2018, 3, 5),
                                      maxTime: DateTime.now(),
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    setState(() {
                                      crDate =
                                          formatDate(date, [yyyy, '-', mm]);
                                    });
                                  },
                                      currentTime: DateTime.parse(
                                          crDate + "-01 00:00:00"),
                                      locale: LocaleType.zh);
                                },
                                child: Row(
                                  children: <Widget>[
                                    new Text(crDate),
                                    new Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.blue,
                                    )
                                  ],
                                )),
                            new RichText(
                                text: new TextSpan(
                                    text: "总共",
                                    children: List.generate(3, (index) {
                                      return TextSpan(
                                          style: TextStyle(
                                              color: (index == 1)
                                                  ? Colors.red
                                                  : Colors.blueGrey,
                                              fontSize:
                                                  (index == 1) ? 18.0 : 14.0),
                                          text: (index == 0)
                                              ? "总共"
                                              : (index == 1)
                                                  ? "${bloc.sendMessagesList == null ? 0 : bloc.sendMessagesList.length}"
                                                  : "条");
                                    })))
                          ],
                        ),
                      ),
                      buildWxArticle(context, bloc.sendMessagesList),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget buildWxArticle(
      BuildContext context, List<MessagetBeanReturnvalueListvo> list) {
    print("buildWxArticle   ${list.toString()}   ");
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new MessageItem(
        model,
        isHome: false,
      );
    }).toList();
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: _children,
    );
  }

  void updateGroupValue(int v) {
    setState(() {
      _currentIndex = v;
    });
  }

  TextSpan _buildSpanList(int index) {}
}
