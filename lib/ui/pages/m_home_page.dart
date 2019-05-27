import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/protocol/messaget_bean_entity.dart';
import 'package:flutter_wanandroid/data/user_info/identity_info.dart';
import 'package:flutter_wanandroid/data/user_info/user_info.dart';
import 'package:flutter_wanandroid/ui/pages/home_school/home_school_page.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:flutter_wanandroid/ui/widgets/message_item.dart';

bool isHomeInit = true;

class MHomePage extends StatelessWidget {
  final IdentityBean mData;
  final String labelId;

  const MHomePage({Key key, this.labelId, this.mData}) : super(key: key);

  Widget buildBanner(BuildContext context, List<BannerModel> list) {
    LogUtil.e(list.toString());
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Swiper(
        indicatorAlignment: AlignmentDirectional.topEnd,
        circular: true,
        interval: const Duration(seconds: 5),
        indicator: NumberSwiperIndicator(),
        children: list.map((model) {
          return new InkWell(
            onTap: () {
              LogUtil.e("BannerModel: " + model.toString());
              NavigatorUtil.pushWeb(context,
                  title: model.title, url: model.url);
            },
            child: new CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: model.imagePath,
              placeholder: new ProgressView(),
              errorWidget: new Icon(Icons.error),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildRepos(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new ReposItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      leftIcon: Icons.book,
      titleId: Ids.recRepos,
      onTap: () {
        NavigatorUtil.pushTabPage(context,
            labelId: Ids.titleReposTree, titleId: Ids.titleReposTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget buildWxArticle(
      BuildContext context, List<MessagetBeanReturnvalueListvo> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new MessageItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      titleColor: Colors.green,
      leftIcon: Icons.library_books,
      titleId: Ids.recWxArticle,
      onTap: () {
        NavigatorUtil.pushTabPage(context,
            labelId: Ids.titleWxArticleTree, titleId: Ids.titleWxArticleTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("HomePage build......");
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.homeEventStream.listen((event) {
      if (labelId == event.labelId) {
        _controller.loadComplete();
      }
    });

    if (isHomeInit) {
      LogUtil.e("HomePage init......");
      isHomeInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: labelId, bean: mData);
        bloc.getHotRecItem(
            mData.roleId.toString(), mData.userVo.schoolId.toString());
        bloc.getVersion();
      });
    }

    return new StreamBuilder(
        stream: bloc.bannerStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<BannerModel>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            isLoading: snapshot.data == null,
            controller: _controller,
            enablePullUp: false,
            onRefresh: () {
              return bloc.onRefresh(labelId: labelId, bean: mData);
            },
            child: new ListView(
              children: <Widget>[
                buildBanner(context, snapshot.data),
                buildMenu(context, bloc.hotRecModel),
                buildSwiper(context),
                buildHonor(context, bloc.recReposModel),
                new StreamBuilder(
                    stream: bloc.recReposStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildRepos(context, snapshot.data);
                    }),
                new StreamBuilder(
                    stream: bloc.recWxArticleStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<MessagetBeanReturnvalueListvo>>
                            snapshot) {
                      return buildWxArticle(context, snapshot.data);
                    }),
              ],
            ),
          );
        });
  }

  Widget buildMenu(BuildContext context, List<ComModel> hotRecModel) {
    if (hotRecModel == null) {
      hotRecModel = [
        ComModel(
          roleName: "",
          menuName: "",
          functionId: 0,
          menuImage: "",
          imgUrl: "",
        ),
        ComModel(
            roleName: "",
            menuName: "",
            functionId: 0,
            menuImage: "",
            imgUrl: ""),
        ComModel(
            roleName: "",
            menuName: "",
            functionId: 0,
            menuImage: "",
            imgUrl: ""),
        ComModel(
            roleName: "",
            menuName: "",
            functionId: 0,
            menuImage: "",
            imgUrl: "")
      ];
    }
    return GridView.count(
        padding: EdgeInsets.only(top: 8.0),
        crossAxisCount: 4,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 4.0,
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        childAspectRatio: 1 / 1.15,
        children: hotRecModel.map<Widget>((ComModel commodel) {
          return new MenuItem(commodel);
        }).toList());
  }

  Widget buildSwiper(BuildContext context) {
    List<ReposModel> recReposModel;
    if (recReposModel == null) {
      recReposModel = [
        ReposModel(studentName: "小明", className: "五年级三班", subTypeName: "得奖了"),
        ReposModel(studentName: "小花", className: "五年级二班", subTypeName: "考上大学"),
        ReposModel(studentName: "小黄", className: "五年级一班", subTypeName: "得奖了"),
        ReposModel(studentName: "小青", className: "五年级九班", subTypeName: "得奖了")
      ];
    }
    return new Container(
        height: 50,
        color: Colors.white,
        padding: EdgeInsets.only(top: 4, left: 10, right: 10, bottom: 4),
        margin: EdgeInsets.all(10),
        child: new Row(
          children: <Widget>[
            new Text(
              '精品\n文章',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontSize: 14.0),
            ),
            Gaps.hGap10,
            new Expanded(
              child: new Swiper(
                children: recReposModel.map<Widget>((ReposModel reposModel) {
                  return new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                        reposModel.className,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      new Text(
                        reposModel.subTypeName,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 14.0),
                      )
                    ],
                  );
                }).toList(),
                controller: new SwiperController(),
                circular: true,
                autoStart: true,
                direction: Axis.vertical,
              ),
            )
          ],
        ));
  }

  Widget buildHonor(BuildContext context, List<ReposModel> recReposModel) {
    if (recReposModel == null) {
      recReposModel = [
        ReposModel(studentName: "小明", className: "五年级三班", subTypeName: "得奖了"),
        ReposModel(studentName: "小花", className: "五年级三班", subTypeName: "考上大学"),
        ReposModel(studentName: "小黄", className: "五年级三班", subTypeName: "得奖了"),
        ReposModel(studentName: "小青", className: "五年级三班", subTypeName: "得奖了")
      ];
    }
    return GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        shrinkWrap: true,
        controller: new ScrollController(keepScrollOffset: false),
        padding: const EdgeInsets.all(0.0),
        childAspectRatio: 0.5,
        children: recReposModel.map<Widget>((ReposModel commodel) {
          return new HonorItem(commodel);
        }).toList());
  }
}

class HonorItem extends StatelessWidget {
  final ReposModel _item;

  HonorItem(this._item);

  @override
  Widget build(BuildContext context) {
    var card = new Card(
      elevation: 5.0, //设置阴影
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))), //设置圆角
      child: new Column(
        // card只能有一个widget，但这个widget内容可以包含其他的widget
        children: [
          new CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl:
                "http://tx.haiqq.com/uploads/allimg/c161216/14QRJ2123510-44E0.jpg",
            placeholder: new ProgressView(),
            errorWidget: new Icon(Icons.error),
          ),
          new Container(
            height: 30.0,
            /* width: 300,*/
            child: new Center(
              child: new Text("名字：${_item.studentName}",
                  style: new TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,

                      fontSize: 10.0)),
            ),
          ),
          new Container(
            height: 30.0,
            /* width: 300,*/
            child: new Center(
              child: new Text("班级：${_item.className}",
                  style: new TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 10.0)),
            ),
          ),
          new Container(
            height: 30.0,
            /* width: 300,*/
            child: new Center(
              child: new Text("荣获奖项：${_item.subTypeName}",
                  style: new TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 10.0)),
            ),
          ),
        ],
      ),
    );

    return card;
    /*new Container(
      height: 200,
      margin:
          new EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
      child:card
    );*/
  }
}

class MenuItem extends StatelessWidget {
  final ComModel _item;

  MenuItem(this._item);

  @override
  Widget build(BuildContext context) {
    print("_item${_item.menuName}   ${_item.menuImage}");

    return new GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new HomeSchoolPage()));
      },
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new CachedNetworkImage(
              width: 66,
              fit: BoxFit.fitWidth,
              imageUrl: _item.menuImage,
              placeholder: new ProgressView(),
              errorWidget: new Icon(Icons.error),
            ),
            new Text(
              _item.menuName,
              style: Theme.of(context).textTheme.body2,
            ),
          ]),
    );
  }
}
