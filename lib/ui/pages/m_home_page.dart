import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/user_info/identity_info.dart';
import 'package:flutter_wanandroid/data/user_info/user_info.dart';
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

  Widget buildWxArticle(BuildContext context, List<MessageModel> list) {
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
        _controller.sendBack(false, event.status);
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
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 30,
                      childAspectRatio: 1,
                    ),
                    itemCount:
                        bloc.hotRecModel != null ? bloc.hotRecModel.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                        //highlightColor: Colors.red,
                        splashColor: Colors.blueAccent,
                        onTap: () {},
                        child: new MenuItem(bloc.hotRecModel[index]),
                      );
                    }),

                /* ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      bloc.hotRecModel != null ? bloc.hotRecModel.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return new InkWell(
                      //highlightColor: Colors.red,
                      splashColor: Colors.blueAccent,
                      onTap: () {

                      },
                      child: new MenuItem(bloc.hotRecModel[index]),
                    );

                  },),*/
                new StreamBuilder(
                    stream: bloc.recReposStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildRepos(context, snapshot.data);
                    }),
                new StreamBuilder(
                    stream: bloc.recWxArticleStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<MessageModel>> snapshot) {
                      return buildWxArticle(context, snapshot.data);
                    }),
              ],
            ),
          );
          ;
        });
  }

  buildMenuItemList() {}
}

class MenuItem extends StatelessWidget {
  final ComModel _item;

  MenuItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin:
          new EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
      child: new Wrap(
        /* mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:MainAxisAlignment.spaceAround,*/
        children: <Widget>[
          new Container(
            height: 50.0,
            /* width: 300,*/
            child: new Center(
              child: new Text(_item.menuName,
                  style: new TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: Colors.transparent,
              border: new Border.all(width: 1.0, color: Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
            ),
          ),
        ],
      ),
    );
  }
}
