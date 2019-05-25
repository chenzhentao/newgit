import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ValueChangeAnimationWidget extends StatefulWidget {
  @override
  ValueChangeAnimationWidgetState createState() =>
      ValueChangeAnimationWidgetState();
}

class ValueChangeAnimationWidgetState
    extends State<ValueChangeAnimationWidget> with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final Animation curve =
    CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = IntTween(begin: 0, end: 3).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
  }
var imageAssetNames = [/*'assets/images/sound_left_0.png',*/'assets/images/sound_left_1.png','assets/images/sound_left_2.png','assets/images/sound_left_3.png'];
  @override
  Widget build(BuildContext context) {
    controller.forward();
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
              body: new Center(
                child: Image.asset(imageAssetNames[animation.value%3]),
              ));
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}