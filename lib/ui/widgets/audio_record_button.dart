import 'dart:async';

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
typedef OnBackResult = void Function(String isOpened);
/* class OnBackResult {
  void onResultBack(String result);
}*/

class _AudioRecordButtonState extends State<AudioRecordButton> {
  bool _isRecording = false;

  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _recorderTxt = '00:00:00';
  double _dbLevel;
  double slider_current_position = 0.0;
  double max_duration = 1.0;
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
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  void startRecorder() async {
    try {
      String path = await flutterSound.startRecorder(null);
      print('startRecorder: $path');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
//        print('startRecorder: $date');
        String txt = DateFormat('ss:SS', 'en_GB').format(date);
//        print('startRecorder    txt: $txt');
        this.setState(() {
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

  void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }

      this.setState(() {
//        widget.onBackResult(flutterSound.);
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }
  void startPlayer() async {
    String path = await flutterSound.startPlayer(null);
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
        stopRecorder();
        print("_onLongPressEnd");
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      child: GestureDetector(
        //双击
        /* onDoubleTap: () {
            print("onDoubleTap");
          },*/
          //单击
          onTap: () {
            print("onTap");
            startPlayer();
          },
        onLongPress: _onLongPress,
        onVerticalDragCancel: _onVerticalDragCancel,
        onLongPressStart: _onLongPressStart,
        onLongPressEnd: _onLongPressEnd,
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragDown: _onVerticalDragDown,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child:
            Text("_recorderTxt  ${_recorderTxt} ${_dbLevel}  ${_isRecording}"),
      ),
    );
  }
}
