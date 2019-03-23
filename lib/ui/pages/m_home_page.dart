import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/user_info/identity_info.dart';
import 'package:flutter_wanandroid/data/user_info/user_info.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

bool isHomeInit = true;

class MHomePage extends StatelessWidget {
  final IdentityBean mData;
  final String labelId;

  const MHomePage({Key key, this.labelId, this.mData}) : super(key: key);

  Widget buildBanner(BuildContext context, List<BannerModel> list) {
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

  Widget buildWxArticle(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new ArticleItem(
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
        bloc.onRefresh(labelId: labelId,bean: mData);
//        bloc.getHotRecItem();
//        bloc.getVersion();
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
                new StreamBuilder(
                    stream: bloc.recItemStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<ComModel> snapshot) {
                      ComModel model = bloc.hotRecModel;
                      if (model == null) {
                        return new Container(
                          height: 0.0,
                        );
                      }
                      int status = Utils.getUpdateStatus(model.version);
                      return new HeaderItem(
                        titleColor: Colors.redAccent,
                        title: status == 0 ? model.content : model.title,
                        extra: status == 0 ? 'Go' : "",
                        onTap: () {
                          if (status == 0) {
                            NavigatorUtil.pushPage(
                                context, RecHotPage(title: model.content),
                                pageName: model.content);
                          } else {
                            NavigatorUtil.launchInBrowser(model.url,
                                title: model.title);
                          }
                        },
                      );
                    }),
                buildBanner(context, snapshot.data),
                new StreamBuilder(
                    stream: bloc.recReposStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildRepos(context, snapshot.data);
                    }),
                new StreamBuilder(
                    stream: bloc.recWxArticleStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildWxArticle(context, snapshot.data);
                    }),
              ],
            ),
          );
        });
  }
}
