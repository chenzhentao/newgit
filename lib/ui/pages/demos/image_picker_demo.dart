import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
class IamgePickerPage extends PopupRoute {
  IamgePickerPage({  RouteSettings settings,}) : super(settings: settings);


  final DatePickerTheme theme= DatePickerTheme();
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black54;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => '';


  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 200);
  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _ImagePickerComponent(
        route: this,
      ),
    );
    ThemeData inheritTheme = Theme.of(context, shadowThemeOnly: true);
    if (inheritTheme != null) {
      bottomSheet = new Theme(data: inheritTheme, child: bottomSheet);
    }
    return bottomSheet;
  }
}
class _ImagePickerComponent extends StatefulWidget {
 final IamgePickerPage route;

  _ImagePickerComponent(
      {Key key,
        @required this.route,});
  @override
  __ImagePickerComponentState createState() => __ImagePickerComponentState();
}

class __ImagePickerComponentState extends State<_ImagePickerComponent> {

  File _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController _controller;
  String _retrieveDataError;

  void _onImageButtonPressed(ImageSource source) async {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.removeListener(_onVideoControllerUpdate);
    }
    if (isVideo) {
      ImagePicker.pickVideo(source: source).then((File file) {
        if (file != null && mounted) {
          setState(() {
            _controller = VideoPlayerController.file(file)
              ..addListener(_onVideoControllerUpdate)
              ..setVolume(1.0)
              ..initialize()
              ..setLooping(true)
              ..play();
          });
        }
      });
    } else {
      try {
        _imageFile = await ImagePicker.pickImage(source: source);
      } catch (e) {
        _pickImageError = e;
      }
      setState(() {});
    }
  }

  void _onVideoControllerUpdate() {
    setState(() {});
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.removeListener(_onVideoControllerUpdate);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Widget _previewVideo(VideoPlayerController controller) {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    } else if (controller.value.initialized) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: AspectRatioVideo(controller),
      );
    } else {
      return const Text(
        'Error Loading Video',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Image.file(_imageFile);
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
          isVideo = true;
          _controller = VideoPlayerController.file(response.file)
            ..addListener(_onVideoControllerUpdate)
            ..setVolume(1.0)
            ..initialize()
            ..setLooping(true)
            ..play();
        } else {
          isVideo = false;
          _imageFile = response.file;
        }
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    DatePickerTheme theme = widget.route.theme;
    return      new GestureDetector(
      child: new AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(

              child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(
              widget.route.animation.value, theme,
              showTitleActions: false),

          child:  new GestureDetector(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        isVideo = false;
                        _onImageButtonPressed(ImageSource.gallery);
                      },
//                      heroTag: 'image0',
//                      tooltip: 'Pick Image from gallery',
                      child: const Icon(Icons.photo_library),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: RaisedButton(
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressed(ImageSource.camera);
                        },
//                        heroTag: 'image1',
//                        tooltip: 'Take a Photo',
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          isVideo = true;
                          _onImageButtonPressed(ImageSource.gallery);
                        },
//                        heroTag: 'video0',
//                        tooltip: 'Pick Video from gallery',
                        child: const Icon(Icons.video_library),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          isVideo = true;
                          _onImageButtonPressed(ImageSource.camera);
                        },
//                        heroTag: 'video1',
//                        tooltip: 'Take a Video',
                        child: const Icon(Icons.videocam),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              )
          );
        },
      ),
    )/*Scaffold(
      body: Center(
        child: Platform.isAndroid
            ? FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'You have not yet picked an image.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return isVideo
                    ? _previewVideo(_controller)
                    : _previewImage();
              default:
                if (snapshot.hasError) {
                  return Text(
                    'Pick image/video error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        )
            : (isVideo ? _previewVideo(_controller) : _previewImage()),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              isVideo = false;
              _onImageButtonPressed(ImageSource.gallery);
            },
            heroTag: 'image0',
            tooltip: 'Pick Image from gallery',
            child: const Icon(Icons.photo_library),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.camera);
              },
              heroTag: 'image1',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                isVideo = true;
                _onImageButtonPressed(ImageSource.gallery);
              },
              heroTag: 'video0',
              tooltip: 'Pick Video from gallery',
              child: const Icon(Icons.video_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                isVideo = true;
                _onImageButtonPressed(ImageSource.camera);
              },
              heroTag: 'video1',
              tooltip: 'Take a Video',
              child: const Icon(Icons.videocam),
            ),
          ),
        ],
      ),
    )*/;
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, this.theme,
      {this.itemCount, this.showTitleActions});

  final double progress;
  final int itemCount;
  final bool showTitleActions;
  final DatePickerTheme theme;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = theme.containerHeight;
    if (showTitleActions) {
      maxHeight += theme.titleHeight;
    }

    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}