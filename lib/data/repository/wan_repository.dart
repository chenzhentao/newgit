import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/net/dio_util.dart';
import 'package:flutter_wanandroid/data/protocol/models.dart';
import 'package:flutter_wanandroid/data/user_info/identity_info.dart';
import 'package:flutter_wanandroid/data/user_info/user_info.dart';

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
    if (baseResp.code != Constant.STATUS_SUCCESS) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      bannerList = baseResp.data.map((value) {
        return BannerModel.fromJson(value);
      }).toList();
//      bannerModelParent = BannerModelParent.fromJson(baseResp.data);;
//      bannerList = bannerModelParent.returnValue;
    }
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
    if (baseResp.code != Constant.STATUS_SUCCESS) {
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
        .request<List>(
            Method.get, WanAndroidApi.HOME_HONOR_LIST,
            data: data);
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

  Future<List<MessageModel>> getWxArticleList(
      {int id, int page: 1, data}) async {

    BaseResp<List> baseResp = await DioUtil()
        .request<List>(Method.post, WanAndroidApi.WXARTICLE_LIST, data: data);
    List<MessageModel> list;
    print(baseResp.toString());
    if (baseResp.code != Constant.STATUS_SUCCESS) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      baseResp.data.map((value) {
        return MessageModel.fromJson(value);
      }).toList();
    }
    return list;
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
    print("baseResp     ${baseResp.data}");
    if (baseResp.status != Constant.STATUS_SUCCESS1.toString()) {
//      print("baseResp     ${baseResp.data}");
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      return IdentityBean.fromJson(baseResp.data);
    }

    return treeList;
  }

  Future<List<returnValue>> postLoginForm(data) async {
    var mOptions = new Options();
    mOptions.data = data;
    mOptions.path = WanAndroidApi.USER_LOGIN;
    mOptions.baseUrl = WanAndroidApi.MESSAGE_U;
    mOptions.method = Method.post;

    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.post, WanAndroidApi.USER_LOGIN,
        data: data, options: mOptions);
    List<returnValue> treeList;
    print("baseResp     ${baseResp}");
    if (baseResp.status != Constant.STATUS_SUCCESS1.toString()) {
      print("baseResp     ${baseResp}");
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return returnValue.fromJson(value);
      }).toList();
    }

    return treeList;
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
