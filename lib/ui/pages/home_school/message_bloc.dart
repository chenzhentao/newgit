/*
import 'package:collection/collection.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:flutter_wanandroid/ui/pages/home_school/my_message_home_page.dart';

class MessageBloc implements BlocBase {
  BehaviorSubject<List<MessageModel>> _sendMessages =
      BehaviorSubject<List<MessageModel>>();

  Sink<List<MessageModel>> get _sendMesssagesSink => _sendMessages.sink;

  Stream<List<MessageModel>> get sendMessageStream => _sendMessages.stream;
  List<MessageModel> _sendMessagesList;
  int _sendMessagePage = 0;

  BehaviorSubject<List<MessageModel>> _receiveMessages =
      BehaviorSubject<List<MessageModel>>();

  Sink<List<MessageModel>> get _receiveMesssagesSink => _receiveMessages.sink;

  Stream<List<MessageModel>> get receiveMessageStream =>
      _receiveMessages.stream;
  List<MessageModel> _receiveMessagesList;
  int _receiveMessagePage = 0;

  WanRepository wanRepository = new WanRepository();

  HttpUtils httpUtils = new HttpUtils();

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future getData(
      {String labelId,
      int page,
      String userId,
      String crDate,
      String readStatus,
      String dataType}) {


    return getMessage(labelId, page, userId, crDate, readStatus, dataType);;
  }

  Future getMessage(String labelId, int page, String userId, String crDate,
      String readStatus, String dataType) async {
    int _id = 408;
    String idType = "";
    switch (labelId) {
      case MessageIds.sendMessageId:
        idType = "1";
        break;
      case MessageIds.receiveMessageId:
        idType = "0";
        break;
    }
    Map<String, String> dataMap = {
      'page': page.toString(),
      'type': dataType,
      'userId': userId,
      'idType': idType,
      'crDate': crDate,
      'readStatus': readStatus
    };

    wanRepository.getWxArticleList(id: _id, data: dataMap).then((list) {
      if (list.length > 6) {
        list = list.sublist(0, 6);
      }
      switch(labelId){
        case MessageIds.sendMessageId:
          _sendMesssagesSink.add(UnmodifiableListView<MessageModel>(list));
          break;
        case MessageIds.receiveMessageId:
          _receiveMesssagesSink.add(UnmodifiableListView<MessageModel>(list));
          break;
      }

    });
  }

  @override
  Future onLoadMore({String labelId,String userId,String crDate,String readStatus,String dataType}) {
    int _page = 0;
    switch (labelId) {
      case MessageIds.sendMessageId:
        _page = ++_sendMessagePage;
        break;
      case MessageIds.receiveMessageId:
        _page = ++_receiveMessagePage;
        break;
    }
    return getData(labelId: labelId, page: _page,userId: userId,crDate: crDate,readStatus: readStatus,dataType: dataType);
  }

  @override
  Future onRefresh({String labelId,String userId,String crDate,String readStatus,String dataType}) {
    switch (labelId) {
      case MessageIds.sendMessageId:
        return getData(labelId: labelId, page: 0,userId: userId,crDate: crDate,readStatus: readStatus,dataType: dataType);
        break;
      case MessageIds.receiveMessageId:
        return getData(labelId: labelId, page: 0,userId: userId,crDate: crDate,readStatus: readStatus,dataType: dataType);
        break;
    }
    return null;
  }
}
*/
