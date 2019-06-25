import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart';

class CurveAnimation extends StatefulWidget {
  @override
  _CurveAnimationState createState() => new _CurveAnimationState();
}

class _CurveAnimationState extends State<CurveAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  GlobalKey _globalKey = new GlobalKey();

  GlobalKey _globalKey1 = new GlobalKey();
  SlideTransition s;
  Offset _offset = Offset(0.0, 0.0);
  Offset _begin = Offset(200.3, 600.0), _end = Offset(5, 11.24);
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((s) {
      _afterLayout();
    });
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    // _animation =
    //     Tween<Offset>(begin: Offset.zero, end: -_end).animate(_controller);
  }

  void _afterLayout() {
    RenderBox box = _globalKey.currentContext.findRenderObject();
    _offset = box.localToGlobal(Offset.zero);
    print(_offset);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    // Animation<Offset> animation =
    //     Tween<Offset>(begin: _begin / 100, end: Offset(200, 100) / 100)
            // .animate(_controller);
    print(MediaQuery.of(context).size);
    return Container(
      child: Stack(
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(200, 100, 0.0),
            child: Container(
              color: Color(0xffff0000),
              height: 100,
              width: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      color: Color(0xffff0000),
                      onPressed: () {
                        _controller.forward();
                        _controller.addStatusListener((s) {
                          if (s == AnimationStatus.completed) {
                            _controller.reverse();
                          }
                        });
                      },
                      child: Text('Animate'),
                    ),
                    _Animated(
                      scale: Tween<Offset>(
                              begin: Offset(300, 900) / 100,
                              end: Offset(200, 100) / 100)
                          .animate(_controller),
                      child: Container(
                        key: _globalKey,
                        height: 100,
                        width: 100,
                        color: Color(0xffff0000),
                      ),
                    ),
                    _Animated(
                      scale: Tween<Offset>(
                              begin: Offset(350, 900) / 100,
                              end: Offset(200, 100) / 100)
                          .animate(_controller),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Color(0xffff0000),
                      ),
                    ),
                    _Animated(
                      scale: Tween<Offset>(
                              begin: Offset(400, 900) / 100,
                              end: Offset(200, 100) / 100)
                          .animate(_controller),
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Color(0xffff0000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Animated extends AnimatedWidget {
  final Widget child;
  _Animated({
    Key key,
    this.child,
    Animation<Offset> scale,
  }) : super(key: key, listenable: scale);
  // TODO: implement listenable
  Animation<Offset> get listenable => super.listenable;
  double get translateX {
    // print(listenable.value);
    double x = listenable.value.dx * 100;
    double val = x;
    // print(x);
    // final val = sin(x / 2) * 100;
    // double val = -sqrt(-x * 2) * 50;

    return val;
  }

  double get translateY {
    double val = listenable.value.dy * 100;
    print(listenable.value);
    return val;
  }

  double get translateZ {
    double val = -listenable.value.dx;
    // print(val);
    // print(-listenable.value.dx);
    if (val <= 1.0)
      return 1.0;
    else
      return val;
  }

  @override
  Widget build(BuildContext context) {
    // final Matrix4 mat =
    //     new Matrix4.translationValues(translateX, translateY, 0.0);

    // return Transform(transform: mat, child: child);
    return _SingleChild(
      child: child,
      offset: Offset(translateX, translateY),
    );
  }
}

class _SingleChild extends SingleChildRenderObjectWidget {
  final Widget child;
  final Offset offset;
  _SingleChild({this.child, this.offset}) : super(child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    print('redner box');
    return _RenderObject(offset: offset);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderObject renderObject) {
    super.updateRenderObject(context, renderObject..offsetUpdate = offset);
  }
}

class _RenderObject extends RenderProxyBox {
  final Offset offset;
  _RenderObject({RenderBox child, this.offset})
      : assert(offset != null),
        _offset = offset,
        super(child);
  Offset _offset;
  set offsetUpdate(Offset of) {
    _offset = of;
    markNeedsPaint();
  }

  @override
  void paint(context, offset) {
    if (child != null) {
      offset = _offset;
      context.paintChild(child, offset);
    }
  }
}