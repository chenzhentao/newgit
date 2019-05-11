import 'dart:collection';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:flutter_wanandroid/data/user_info/identity_info.dart';

class MainBloc implements BlocBase {
  ///****** ****** ****** Home ****** ****** ****** /

  BehaviorSubject<List<BannerModel>> _banner =
      BehaviorSubject<List<BannerModel>>();

  Sink<List<BannerModel>> get _bannerSink => _banner.sink;

  Stream<List<BannerModel>> get bannerStream => _banner.stream;

  BehaviorSubject<List<ReposModel>> _recRepos =
      BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _recReposSink => _recRepos.sink;

  Stream<List<ReposModel>> get recReposStream => _recRepos.stream;
  List<ReposModel> recReposModel;
  BehaviorSubject<List<MessageModel>> _recWxArticle =
      BehaviorSubject<List<MessageModel>>();

  Sink<List<MessageModel>> get _recWxArticleSink => _recWxArticle.sink;

  Stream<List<MessageModel>> get recWxArticleStream => _recWxArticle.stream;

  ///****** ****** ****** Home ****** ****** ****** /

  ///****** ****** ****** Repos ****** ****** ****** /
  BehaviorSubject<List<ReposModel>> _repos =
      BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _reposSink => _repos.sink;

  Stream<List<ReposModel>> get reposStream => _repos.stream;

  List<ReposModel> _reposList;
  int _reposPage = 0;

  ///****** ****** ****** Repos ****** ****** ****** /

  ///****** ****** ****** Events ****** ****** ****** /

  BehaviorSubject<List<ReposModel>> _events =
      BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _eventsSink => _events.sink;

  Stream<List<ReposModel>> get eventsStream => _events.stream;

  List<ReposModel> _eventsList;
  int _eventsPage = 0;

  ///****** ****** ****** Repos ****** ****** ****** /

  ///****** ****** ****** Events ****** ****** ****** /

  BehaviorSubject<List<MessageModel>> _sendMessages =
      BehaviorSubject<List<MessageModel>>();

  Sink<List<MessageModel>> get _sendMesssagesSink => _sendMessages.sink;

  Stream<List<MessageModel>> get sendMessageStream => _sendMessages.stream;
  List<MessageModel> sendMessagesList;
  int _sendMessagePage = 0;

  BehaviorSubject<List<MessageModel>> _receiveMessages =
      BehaviorSubject<List<MessageModel>>();

  Sink<List<MessageModel>> get _receiveMesssagesSink => _receiveMessages.sink;

  Stream<List<MessageModel>> get receiveMessageStream =>
      _receiveMessages.stream;
  List<MessageModel> receiveMessagesList;
  int _receiveMessagePage = 0;

  ///****** ****** ****** Events ****** ****** ****** /

  ///****** ****** ****** System ****** ****** ****** /

  BehaviorSubject<List<TreeModel>> _tree = BehaviorSubject<List<TreeModel>>();

  Sink<List<TreeModel>> get _treeSink => _tree.sink;

  Stream<List<TreeModel>> get treeStream => _tree.stream;

  List<TreeModel> _treeList;

  ///****** ****** ****** System ****** ****** ****** /

  ///****** ****** ****** Version ****** ****** ****** /

  BehaviorSubject<VersionModel> _version = BehaviorSubject<VersionModel>();

  Sink<VersionModel> get _versionSink => _version.sink;

  Stream<VersionModel> get versionStream => _version.stream.asBroadcastStream();

  VersionModel _versionModel;

  ///****** ****** ****** Version ****** ****** ****** /

  ///****** ****** ****** ****** ****** ****** /
  BehaviorSubject<StatusEvent> _homeEvent = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get _homeEventSink => _homeEvent.sink;

  Stream<StatusEvent> get homeEventStream =>
      _homeEvent.stream.asBroadcastStream();

  ///****** ****** ****** ****** ****** ****** /

  ///****** ****** ****** ****** ****** ****** /

  ///****** ****** ****** ****** ****** ****** /

  ///****** ****** ****** personal ****** ****** ****** /

  BehaviorSubject<List<ComModel>> _recItem = BehaviorSubject<List<ComModel>>();

  Sink<List<ComModel>> get _recItemSink => _recItem.sink;

  Stream<List<ComModel>> get recItemStream =>
      _recItem.stream.asBroadcastStream();

  List<ComModel> hotRecModel;

  BehaviorSubject<List<ComModel>> _recList = BehaviorSubject<List<ComModel>>();

  Sink<List<ComModel>> get _recListSink => _recList.sink;

  Stream<List<ComModel>> get recListStream =>
      _recList.stream.asBroadcastStream();

  List<ComModel> hotRecList;

  ///****** ****** ****** personal ****** ****** ****** /

  WanRepository wanRepository = new WanRepository();

  HttpUtils httpUtils = new HttpUtils();

  MainBloc() {
    LogUtil.e("MainBloc......");
  }

  @override
  Future getData(
      {String labelId,
      int page,
      IdentityBean bean,
      String userId,
      String crDate,
      String readStatus,
      String dataType}) {
    print(
        "  getData     ${userId}   ${crDate}   ${readStatus}    ${dataType}    ");
    switch (labelId) {
      case Ids.titleHome:
        return getHomeData(labelId, bean);
        break;
      case Ids.titleRepos:
        return getArticleListProject(labelId, page);
        break;
      case Ids.titleEvents:
        return getArticleList(labelId, page);
        break;
      case Ids.titleSystem:
        return getTree(labelId);
        break;
      case Ids.sendMessageId:
        return getMessage(labelId, page, userId, crDate, readStatus, dataType);
        break;
      case Ids.receiveMessageId:
        return getMessage(labelId, page, userId, crDate, readStatus, dataType);
        break;
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }
  }

  @override
  Future onLoadMore(
      {String labelId,
      String userId,
      String crDate,
      String readStatus,
      String dataType}) {
    int _page = 0;
    switch (labelId) {
      case Ids.titleHome:
        break;
      case Ids.titleRepos:
        _page = ++_reposPage;
        break;
      case Ids.titleEvents:
        _page = ++_eventsPage;
        break;
      case Ids.titleSystem:
        break;
      case Ids.sendMessageId:
        _page = ++_sendMessagePage;
        break;
      case Ids.receiveMessageId:
        _page = ++_receiveMessagePage;
        break;
      default:
        break;
    }
    LogUtil.e("onLoadMore labelId: $labelId" +
        "   _page: $_page" +
        "   _reposPage: $_reposPage");
    return getData(
        labelId: labelId,
        page: _page,
        userId: userId,
        crDate: crDate,
        readStatus: readStatus,
        dataType: dataType);
  }

  @override
  Future onRefresh(
      {String labelId,
      IdentityBean bean,
      String userId,
      String crDate,
      String readStatus,
      String dataType}) {
    switch (labelId) {
      case Ids.titleHome:
        getHotRecItem(bean.roleId.toString(), bean.userVo.schoolId.toString());
        break;
      case Ids.titleRepos:
        _reposPage = 0;
        break;
      case Ids.titleEvents:
        _eventsPage = 0;
        break;
      case Ids.titleSystem:
        break;
      case Ids.sendMessageId:
        break;
      case Ids.receiveMessageId:
        break;
      case Ids.sendMessageId:
        return getData(
            labelId: labelId,
            page: 0,
            userId: userId,
            crDate: crDate,
            readStatus: readStatus,
            dataType: dataType);
        break;
      case Ids.receiveMessageId:
        print(
            "  onRefresh     ${userId}   ${crDate}   ${readStatus}    ${dataType}    ");
        return getData(
            labelId: labelId,
            page: 0,
            userId: userId,
            crDate: crDate,
            readStatus: readStatus,
            dataType: dataType);
        break;
      default:
        break;
    }
    LogUtil.e("onRefresh labelId: $labelId" + "   _reposPage: $_reposPage");
    return getData(
        labelId: labelId,
        page: 0,
        bean: bean,
        userId: userId,
        crDate: crDate,
        readStatus: readStatus,
        dataType: dataType);
  }

  Future getMessage(String labelId, int page, String userId, String crDate,
      String readStatus, String dataType) async {
    if (page == 0)
      switch (labelId) {
        case Ids.sendMessageId:
          if (sendMessagesList != null) {
            sendMessagesList.clear();
          }

          break;
        case Ids.receiveMessageId:
          if (receiveMessagesList != null) {
            receiveMessagesList.clear();
          }
          break;
      }
    int _id = 408;
    String idType = "";
    switch (labelId) {
      case Ids.sendMessageId:
        idType = "1";
        break;
      case Ids.receiveMessageId:
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
      print(" wanRepository.getWxArticleLis   ${list.toString()}   ");
      switch (labelId) {
        case Ids.sendMessageId:
          if (sendMessagesList == null) {
            sendMessagesList = new List();
          }
          sendMessagesList.addAll(list);
          _sendMesssagesSink.add(UnmodifiableListView<MessageModel>(list));
          print(" Ids.sendMessageId   ${sendMessagesList.toString()}   ");
          break;
        case Ids.receiveMessageId:
          if (receiveMessagesList == null) {
            receiveMessagesList = new List();
          }
          receiveMessagesList.addAll(list);
          _receiveMesssagesSink.add(UnmodifiableListView<MessageModel>(list));
          print(" Ids.receiveMessageId   ${receiveMessagesList.toString()}   ");
          break;
      }
    });
  }

  Future getHomeData(String labelId, IdentityBean bean) {
    getRecRepos(labelId, bean.userVo.schoolId.toString());
    getRecWxArticle(labelId, 0, "1", bean.userVo.id.toString(), "0");
    return getBanner(labelId, bean);
  }

  Future getBanner(String labelId, IdentityBean bean) {
    Map<String, String> mDataMap = {
      'schoolId': bean.userVo.schoolId.toString()
    };

    return wanRepository.getBanner(mDataMap).then((list) {
      print("baseResp     2222222222");
      _bannerSink.add(UnmodifiableListView<BannerModel>(list));
    });
  }

  Future getRecRepos(String labelId, String schoolId) async {
    Map<String, String> mDataMap = {'schoolId': schoolId};
    wanRepository.getProjectList(data: mDataMap).then((list) {
      if (list.length > 6) {
        list = list.sublist(0, 6);
      }
      recReposModel = list;
      _recReposSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }

  Future getRecWxArticle(String labelId, int page, String type, String userId,
      String crDate) async {
    int _id = 408;
    Map<String, String> dataMap = {
      'page': page.toString(),
      'type': type,
      'userId': userId,
      'idType': "0",
      'crDate': crDate
    };

    wanRepository.getWxArticleList(id: _id, data: dataMap).then((list) {
      if (list.length > 6) {
        list = list.sublist(0, 6);
      }
      _recWxArticleSink.add(UnmodifiableListView<MessageModel>(list));
    });
  }

  Future getArticleListProject(String labelId, int page) {
    return wanRepository.getArticleListProject(page).then((list) {
      if (_reposList == null) {
        _reposList = new List();
      }
      if (page == 0) {
        _reposList.clear();
      }
      _reposList.addAll(list);
      _reposSink.add(UnmodifiableListView<ReposModel>(_reposList));
      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.completed
              : RefreshStatus.idle));
    }).catchError(() {
      _reposPage--;
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getArticleList(String labelId, int page) {
    return wanRepository.getArticleList(page: page).then((list) {
      if (_eventsList == null) {
        _eventsList = new List();
      }
      if (page == 0) {
        _eventsList.clear();
      }
      _eventsList.addAll(list);
      _eventsSink.add(UnmodifiableListView<ReposModel>(_eventsList));
      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.completed
              : RefreshStatus.idle));
    }).catchError(() {
      _eventsPage--;
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getTree(String labelId) {
    return wanRepository.getTree().then((list) {
      if (_treeList == null) {
        _treeList = new List();
      }

      for (int i = 0, length = list.length; i < length; i++) {
        String tag = Utils.getPinyin(list[i].name);
        if (RegExp("[A-Z]").hasMatch(tag)) {
          list[i].tagIndex = tag;
        } else {
          list[i].tagIndex = "#";
        }
      }
      SuspensionUtil.sortListBySuspensionTag(list);

      _treeList.clear();
      _treeList.addAll(list);
      _treeSink.add(UnmodifiableListView<TreeModel>(_treeList));
      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.completed
              : RefreshStatus.idle));
    }).catchError(() {
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getVersion() async {
    httpUtils.getVersion().then((model) {
      _versionModel = model;
      _versionSink.add(_versionModel);
    });
  }

  Future getHotRecItem(String roleId, String schoolId) async {
    Map<String, String> dataMap = {
      'schoolId': schoolId,
      'roleId': roleId,
    };

    httpUtils.getRecItem(dataMap).then((model) {
      hotRecModel = model;
      _recItemSink.add(hotRecModel);
    });
  }

  Future getHotRecList(String labelId) async {
    httpUtils.getRecList().then((list) {
      hotRecList = list;
      _recListSink.add(UnmodifiableListView<ComModel>(list));
      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.completed
              : RefreshStatus.idle));
    }).catchError(() {
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  void test() {
    LogUtil.e("MainBloc test 1.....");
  }

  @override
  void dispose() {
    _banner.close();
    _recRepos.close();
    _recWxArticle.close();
    _repos.close();
    _events.close();
    _tree.close();
    _homeEvent.close();
    _version.close();
    _recItem.close();
    _recList.close();
  }
}
