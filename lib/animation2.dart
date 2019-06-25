import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class MoveContainer extends StatefulWidget {
  int coinCount;
  MoveContainer({Key key, this.coinCount}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MyMoveContainer();
  }
}

class _MyMoveContainer extends State<MoveContainer>
    with TickerProviderStateMixin {
  GlobalKey _globalKey = new GlobalKey();
  AnimationController _controller;
  Animation<Offset> _offset;
  Offset begin = Offset(0.0, 0.0);
  Offset end = Offset(400.0, 500.0);
  Offset local;
  var countOpacity = 1.0;
  var extraSize = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _offset = Tween<Offset>(begin: begin / 100, end: -end / 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.7,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _offset.addListener(() {
      setState(() {
        extraSize = _controller.value * 60;
        countOpacity =
            countOpacity < 0.31 ? 0.0 : 1.0 - _controller.value * 0.7;
        widget.coinCount =
            countOpacity < 0.32 ? widget.coinCount + 3 : widget.coinCount;
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SlideTransition(
      position: _offset,
      child: Opacity(
        opacity: countOpacity < 0.31 ? 0.0 : countOpacity,
        child: Container(
          height: height * .1 + extraSize,
          width: width * .1 + extraSize,
          // color: Colors.green,

          child: FlareActor(
            "assets/coin.flr",
            animation: "coin",
          ),
        ),
      ),
    );
  }
}
