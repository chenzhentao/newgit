import 'dart:async';

import 'package:flutter_wanandroid/res/res_index.dart';
import 'package:flutter_wanandroid/utils/utils.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';

class AudioRecordButton extends StatefulWidget {
  AudioRecordButton(this.onBackResult);

  final OnBackResult onBackResult;

  @override
  _AudioRecordButtonState createState() => _AudioRecordButtonState();
}

typedef OnBackResult = void Function(String isOpened, int audioLength);

class _AudioRecordButtonState extends State<AudioRecordButton> {
  void startRecorder() async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DialogContent();
        });
    if(result is Map){

      widget.onBackResult(result["audioPath"],result["audioLongth"]);
    }
  }

  get _onLongPress => () {
        print("_onLongPress");
//        startRecorder;
      };

  get _onVerticalDragCancel => () {
        print("_onVerticalDragCancel");
      };

  get _onLongPressStart => (LongPressStartDetails details) {
        print("_onLongPressStart");
        startRecorder();
      };

  get _onLongPressEnd => (LongPressEndDetails details) {

        print("_onLongPressEnd");
      };

  get _onVerticalDragDown => (DragDownDetails details) {
        print("_onVerticalDragDown${details.toString()}");
      };

  get _onVerticalDragStart => (DragStartDetails details) {
        print("_onVerticalDragStart${details.toString()}");
      };

  get _onVerticalDragUpdate => (DragUpdateDetails details) {
        print("_onVerticalDragUpdate${details.toString()}");
      };

  get _onVerticalDragEnd => (DragEndDetails details) {
        print("_onVerticalDragEnd${details.toString()}");
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //双击
      /* onDoubleTap: () {
            print("onDoubleTap");
          },*/
      //单击
      onTap: () {
        print("onTap");
//        startPlayer(null);
      },
      onLongPress: _onLongPress,
      onVerticalDragCancel: _onVerticalDragCancel,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragDown: _onVerticalDragDown,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Text(
        "长按录音",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

class DialogContent extends StatefulWidget {
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  bool _isRecording = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  bool _isPlaying = false;

  String _recorderTxt = '00:00:00';
  double _dbLevel;
  double slider_current_position = 0.0;
  double max_duration = 1.0;
  String audioPath;
  int audioLongth;

  @override
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
    startRecorder();
  }

  void startPlayer(String videoPath) async {
    String path = await flutterSound.startPlayer(videoPath);
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          slider_current_position = e.currentPosition;
          max_duration = e.duration;

          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          if (mounted)
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

  void startRecorder() async {
    try {
      audioPath = await flutterSound.startRecorder(null);
      print('startRecorder: $audioPath');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
//        print('startRecorder: $date');
        String txt = DateFormat('ss:SS', 'en_GB').format(date);

//        print('startRecorder    txt: $txt');
        this.setState(() {
          audioLongth = date.second;
          this._recorderTxt = txt.substring(0, 5);
        });
      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
        print("got update -> $value");
        setState(() {
          this._dbLevel = value;
        });
      });

      this.setState(() {
        this._isRecording = true;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  void stopRecorder(isConfirm) async {
    try {
      String result = await flutterSound.stopRecorder();

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }
      this.setState(() {
        if (isConfirm)
          Navigator.of(context)
              .pop({"audioPath": audioPath, "audioLongth": audioLongth});
        else
          Navigator.of(context).pop();
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey,
      title: null,
      content: Container(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  Utils.getImgPath('recorder'),
                  height: 130,
                  fit: BoxFit.fitWidth,
                ),
                Image.asset(
                  Utils.getImgPath('v1'),
                  height: 130,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
            Gaps.vGap5,
            Text("想说啥,说吧${_recorderTxt}"),
            Gaps.vGap5,
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () {
                  stopRecorder(false);
                },
              ),
              Gaps.hGap15,
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  "确认",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () {
                  stopRecorder(true);
                },
              ),
            ])
          ],
        ),
      ),
    );
  }
}
