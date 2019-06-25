import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class AnimationPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool dragAble = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..addListener(() {
        setState(() {});
      });
    _controller.forward();

    _animation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.6,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    print(
        "hello what is,.. the value of the animation in thius.....${_animation.value}");
    Size screenSize = mediaQueryData.size;
    double levelsWidth = -100.0 +
        ((mediaQueryData.orientation == Orientation.portrait)
            ? screenSize.width
            : screenSize.height);

    print("hello what is darapble is.......$dragAble");
    return Scaffold(
      body: WillPopScope(
          // No way to get back
          onWillPop: () async => false,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: ShadowedText(
              //       text: 'data',
              //       color: Colors.white,
              //       fontSize: 12.0,
              //       offset: Offset(1.0, 1.0),
              //     ),
              //   ),
              // ),

              //92.0, 772.5, 168.8, 849.3
              Positioned(
                left: 200.0,
                top: _animation.value * 572.5,
                // right: 168.8-100,
                // bottom: 849.3-100,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    height: 150.0,
                    width: 110.0,
                    // color: Colors.green,
                    child: FlareActor(
                      "assets/coin.flr",
                      // alignment: Alignment.bottomLeft,
                      // isPaused: _isPaused,
                      animation:  "coinn",
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class DoubleCurvedContainer extends StatelessWidget {
  DoubleCurvedContainer({
    Key key,
    @required this.width,
    @required this.height,
    @required this.child,
    @required this.outerColor,
    @required this.innerColor,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final Color outerColor;
  final Color innerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      color: Colors.black.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          color: outerColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: innerColor,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ShadowedText extends StatelessWidget {
  ShadowedText({
    Key key,
    @required this.text,
    this.fontSize: 16.0,
    this.color: Colors.white,
    this.offset: const Offset(1.0, 1.0),
    this.shadowOpacity: 1.0,
  }) : super(key: key);

  final String text;
  final Color color;
  final Offset offset;
  final double shadowOpacity;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Transform.translate(
          offset: offset,
          child: Text(
            text,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.black.withOpacity(shadowOpacity)),
          )),
      Text(
        text,
        style: TextStyle(fontSize: fontSize, color: color),
      ),
    ]);
  }
}
