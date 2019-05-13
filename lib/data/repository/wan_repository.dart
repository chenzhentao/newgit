import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/net/dio_util.dart';
import 'package:flutter_wanandroid/data/protocol/messaget_bean_entity.dart';
import 'package:flutter_wanandroid/data/protocol/models.dart';
import 'package:flutter_wanandroid/data/user_info/identity_info.dart';
import 'package:flutter_wanandroid/data/user_info/user_info.dart';
import 'package:flutter_wanandroid/models/message_detail_bean_entity.dart';

//data) async {
//    var mOptions = new Options();
//    mOptions.data = data;
//    mOptions.path = WanAndroidApi.USER_LOGIN;
//    mOptions.baseUrl = WanAndroidApi.MESSAGE_U;
//    mOptions.method = Method.post;
//
//    BaseResp<List> baseResp = await DioUtil().request<List>(Method.post,
//        WanAndroidApi.USER_LOGIN, data: data, options: mOptions);
class WanRepository {
  Future<List<BannerModel>> getBanner(data) async {
    var mOptions = new Options();
    mOptions.data = data;
    mOptions.path = WanAndroidApi.MYSCHOOL;
    mOptions.baseUrl = WanAndroidApi.MESSAGE_U;
    mOptions.method = Method.get;
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.MYSCHOOL,
        data: data, options: mOptions);
    BannerModelParent bannerModelParent;
    List<BannerModel> bannerList;
//    print("baseResp     baseResp.code${baseResp.code}");code
//    print("baseResp     baseResp.data${baseResp.data}");

    if (baseResp.status != Constant.STATUS_SUCCESS1) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      bannerList = baseResp.data.map((value) {
        return BannerModel.fromJson(value);
      }).toList();
//      bannerModelParent = BannerModelParent.fromJson(baseResp.data);;
//      bannerList = bannerModelParent.returnValue;
    }
//    print("baseResp     111111111111$bannerList");
    return bannerList;
  }

  Future<List<ComModel>> getMenuItem(data) async {
    var mOptions = new Options();
    mOptions.data = data;
    mOptions.path = WanAndroidApi.MYSCHOOL;
    mOptions.baseUrl = WanAndroidApi.MESSAGE_U;
    mOptions.method = Method.get;
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.MY_MENU,
        data: data, options: mOptions);
    BannerModelParent bannerModelParent;
    List<ComModel> bannerList;
    if (baseResp.status != Constant.STATUS_SUCCESS1) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      bannerList = baseResp.data.map((value) {
        return ComModel.fromJson(value);
      }).toList();
//      bannerModelParent = BannerModelParent.fromJson(baseResp.data);;
//      bannerList = bannerModelParent.returnValue;
    }
    return bannerList;
  }

  Future<List<ReposModel>> getArticleListProject(int page) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
        Method.get,
        WanAndroidApi.getPath(
            path: WanAndroidApi.ARTICLE_LISTPROJECT, page: page));
    List<ReposModel> list;
    if (baseResp.status != Constant.STATUS_SUCCESS1) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ReposModel>> getArticleList({int page, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.get,
        WanAndroidApi.getPath(path: WanAndroidApi.ARTICLE_LIST, page: page),
        data: data);
    List<ReposModel> list;
    if (baseResp.code != Constant.STATUS_SUCCESS) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<TreeModel>> getTree() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.TREE));
    List<TreeModel> treeList;
    if (baseResp.code != Constant.STATUS_SUCCESS) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return treeList;
  }

  Future<List<ReposModel>> getProjectList({int page: 1, data}) async {
    BaseResp<List> baseResp = await DioUtil()
        .request<List>(Method.get, WanAndroidApi.HOME_HONOR_LIST, data: data);
    List<ReposModel> list;
    if (baseResp.code != Constant.STATUS_SUCCESS) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      baseResp.data.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<MessagetBeanReturnvalue> getWxArticleList(
      {int id, int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
        Method.post, WanAndroidApi.WXARTICLE_LIST,
        data: data);

    if (baseResp.status != null &&
        baseResp.status != Constant.STATUS_SUCCESS1) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      var listVo = baseResp.data;
      if (listVo != null && listVo is Map) {
        var listModel = MessagetBeanReturnvalue.fromJson(listVo);
        return listModel;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<MessageDetailBeanReturnvalue> getMessageDetail(data) async {
    print(data.toString());
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
        Method.get, WanAndroidApi.SCHOOL_FAMILY_COMMENT,
        data: data);

    if (baseResp.status != null &&
        baseResp.status != Constant.STATUS_SUCCESS1) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      var listVo = baseResp.data;
      if (listVo != null && listVo is Map) {
        var listModel = MessageDetailBeanReturnvalue.fromJson(listVo);
        return listModel;
      } else {
        return null;
      }
    }
    return null;
  }
  Future<MessageDetailBeanReturnvalue> replayMessages(data) async {
    print(data.toString());
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
        Method.post, WanAndroidApi.SCHOOL_FAMILY_ADD_COMMENT,
        data: data);

    if (baseResp.status != null &&
        baseResp.status != Constant.STATUS_SUCCESS1) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      var listVo = baseResp.data;
      if (listVo != null && listVo is Map) {
        var listModel = MessageDetailBeanReturnvalue.fromJson(listVo);
        return listModel;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<List<TreeModel>> getWxArticleChapters() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get,
        WanAndroidApi.getPath(path: WanAndroidApi.WXARTICLE_CHAPTERS));
    List<TreeModel> treeList;
    if (baseResp.code != Constant.STATUS_SUCCESS) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return treeList;
  }

  Future<IdentityBean> getIdentityForm(data) async {
    var mOptions = new Options();
    mOptions.data = data;
    mOptions.path = WanAndroidApi.USER_LOGIN;
    mOptions.baseUrl = WanAndroidApi.MESSAGE_U;
    mOptions.method = Method.get;

    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
        Method.get, WanAndroidApi.GET_INFORMATION,
        data: data, options: mOptions);
    IdentityBean treeList;

    if (baseResp.status != Constant.STATUS_SUCCESS1) {
//      print("baseResp     ${baseResp.data}");
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      return IdentityBean.fromJson(baseResp.data);
    }

    return treeList;
  }

  Future<LogingResult> postLoginForm(data) async {
    var mOptions = new Options();
    mOptions.data = data;
    mOptions.path = WanAndroidApi.USER_LOGIN;
    mOptions.baseUrl = WanAndroidApi.MESSAGE_U;
    mOptions.method = Method.post;

    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.post, WanAndroidApi.USER_LOGIN,
        data: data, options: mOptions);
    List<LoginReturnValue> treeList;
//    print("baseResp     ${baseResp}");
    if (baseResp.status != Constant.STATUS_SUCCESS1) {
//      print("baseResp     ${baseResp}");
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return LoginReturnValue.fromJson(value);
      }).toList();
    }
    LogingResult logingResult = new LogingResult(
        baseResp.status, baseResp.msg, treeList, baseResp.code);
    return logingResult;
  }

  Future<List<TreeModel>> getProjectTree() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.PROJECT_TREE));
    List<TreeModel> treeList;
    if (baseResp.code != Constant.STATUS_SUCCESS) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return treeList;
  }
}
