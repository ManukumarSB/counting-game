import 'dart:async';
import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class CountAnime extends StatefulWidget {
  int index;
  int rndVal;
  var selectedIndex;
  int countVal;
  CountAnime(this.index, this.rndVal, this.selectedIndex, this.countVal);
  @override
  CountAnimeState createState() {
    return new CountAnimeState();
  }
}

enum ScoreWidgetStatus { HIDDEN, BECOMING_VISIBLE, VISIBLE, BECOMING_INVISIBLE }

class CountAnimeState extends State<CountAnime> with TickerProviderStateMixin {
  MediaQueryData queryData;
  int _counter = 0;
  int countVal = 0;
  // var selectedIndex = [];
  int counting = 0;
  double _sparklesAngle = 0.0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final duration = new Duration(milliseconds: 400);
  final oneSecond = new Duration(seconds: 1);
  Random random;
  Timer holdTimer, scoreOutETA;
  AnimationController scoreInAnimationController,
      scoreOutAnimationController,
      scoreSizeAnimationController,
      sparklesAnimationController;
  Animation scoreOutPositionAnimation, sparklesAnimation;

  initState() {
    super.initState();
    random = new Random();
    scoreInAnimationController = new AnimationController(
        duration: new Duration(milliseconds: 150), vsync: this);
    scoreInAnimationController.addListener(() {
      setState(() {}); // Calls render function
    });

    scoreOutAnimationController =
        new AnimationController(vsync: this, duration: duration);
    scoreOutPositionAnimation = new Tween(begin: 100.0, end: 150.0).animate(
        new CurvedAnimation(
            parent: scoreOutAnimationController, curve: Curves.easeOut));
    scoreOutPositionAnimation.addListener(() {
      setState(() {});
    });
    scoreOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
      }
    });

    scoreSizeAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 150));
    scoreSizeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        scoreSizeAnimationController.reverse();
      }
    });
    scoreSizeAnimationController.addListener(() {
      setState(() {});
    });

    sparklesAnimationController =
        new AnimationController(vsync: this, duration: duration);
    sparklesAnimation = new CurvedAnimation(
        parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener(() {
      setState(() {});
    });
  }

  dispose() {
    super.dispose();
    scoreInAnimationController.dispose();
    scoreOutAnimationController.dispose();
  }

  void increment(Timer t) {
    scoreSizeAnimationController.forward(from: 0.0);
    sparklesAnimationController.forward(from: 0.0);
    for (int i = 0; i < widget.selectedIndex.length; i++) {
      if (widget.selectedIndex[i] == 1) {
       
          if(counting <= widget.rndVal){
           setState(() {
          counting = counting + 1;
        });
          }
      }
    }
    setState(() {
     countVal = counting;
      widget.countVal = widget.selectedIndex[widget.index] == 0
          ? widget.countVal + counting + 1
          : countVal;
      // _counter  =
      _sparklesAngle = random.nextDouble() * (2 * pi);
      widget.selectedIndex[widget.index] = 1;
    });
  }

  void onTapDown(TapDownDetails tap) {
    // User pressed the button. This can be a tap or a hold.
    if (scoreOutETA != null) {
      scoreOutETA.cancel(); // We do not want the score to vanish!
    }
    if (_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
      // We tapped down while the widget was flying up. Need to cancel that animation.
      scoreOutAnimationController.stop(canceled: true);
      _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
    } else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN) {
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
      scoreInAnimationController.forward(from: 20.0);
    }
    increment(null); // Take care of tap
    holdTimer = new Timer.periodic(duration, increment);
    setState(() {
      Flame.audio.play('smash.mp3');
    });
    holdTimer.cancel(); // Takes care of hold
  }

  void onTapUp(TapUpDetails tap) {
    // User removed his finger from button.
    scoreOutETA = new Timer(oneSecond, () {
      scoreOutAnimationController.forward(from: 0.0);
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
    });
    holdTimer.cancel();
  }

  Widget getScoreButton(int index) {
    var scorePosition = 0.0;
    var scoreOpacity = 0.0;
    var extraSize = 0.0;
    switch (_scoreWidgetStatus) {
      case ScoreWidgetStatus.HIDDEN:
        break;
      case ScoreWidgetStatus.BECOMING_VISIBLE:
      case ScoreWidgetStatus.VISIBLE:
        scorePosition = scoreInAnimationController.value * 80;
        scoreOpacity = scoreInAnimationController.value;
        extraSize = scoreSizeAnimationController.value * 5;
        break;
      case ScoreWidgetStatus.BECOMING_INVISIBLE:
        scorePosition = scoreOutPositionAnimation.value;
        scoreOpacity = 1.0 - scoreOutAnimationController.value;
    }

    var stackChildren = <Widget>[];

    var firstAngle = _sparklesAngle;
    var sparkleRadius = (sparklesAnimationController.value * 50);
    var sparklesOpacity = (1 - sparklesAnimation.value);

    for (int i = 0; i < 5; ++i) {
      var currentAngle = (firstAngle + ((2 * pi) / 5) * (i));
      var sparklesWidget = new Positioned(
        child: new Transform.rotate(
            angle: currentAngle - pi / 2,
            child: new Opacity(
                opacity: sparklesOpacity,
                child: new Image.asset(
                  "assets/sparkles.png",
                  width: 15.0,
                  height: 15.0,
                ))),
        left: (sparkleRadius * cos(currentAngle)) + 5,
        top: (sparkleRadius * sin(currentAngle)) + 5,
      );
      stackChildren.add(sparklesWidget);
      print("score position   $scorePosition");
    }

    stackChildren.add(new Opacity(
        opacity: scoreOpacity,
        child: new Container(
            // counter display container
            height: 30.0 + extraSize,
            width: 30.0 + extraSize,
            decoration: new ShapeDecoration(
              shape: new CircleBorder(side: BorderSide.none),
              color: Colors.pink,
            ),
            child: new Center(
                child: new Text(
              widget.countVal.toString(),
              style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            )))));

    var widget1 = new Positioned(
        child: new Stack(
          alignment: FractionalOffset.center,
          overflow: Overflow.visible,
          children: stackChildren,
        ),
        bottom: scorePosition);
    return widget1;
  }

  Widget getClapButton(int index) {
    // Using custom gesture detector because we want to keep increasing the claps
    // when user holds the button.

    var extraSize = 0.0;
    if (_scoreWidgetStatus == ScoreWidgetStatus.VISIBLE ||
        _scoreWidgetStatus == ScoreWidgetStatus.BECOMING_VISIBLE) {
      extraSize = scoreSizeAnimationController.value * 20;
    }
    return Container(
      width: 70.0 - extraSize,
      height: 70.0 - extraSize,
      // color: Colors.red,
      child: Image(
        image: widget.selectedIndex[widget.index] == 0? AssetImage("assets/orange.png"):AssetImage("assets/orange2.png") ,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // selectedIndex.add(0)* widget.rndVal
    return GestureDetector(
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: new Stack(
          alignment: FractionalOffset.center,
          overflow: Overflow.visible,
          children: <Widget>[
            getScoreButton(widget.index),
            getClapButton(widget.index),
          ],
        ),
      ),
    );
  }
}
