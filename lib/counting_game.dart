import 'dart:async';
import 'dart:math';

import 'package:counting/count_animation.dart';
import 'package:counting/header_body.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

class CountingGame extends StatefulWidget {
  _CountingGameState createState() => _CountingGameState();
}

class _CountingGameState extends State<CountingGame>
    with TickerProviderStateMixin {
  Orientation orientation;
  MediaQueryData queryData;
  List<int> dragBoxData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> quetionData = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int value;
  int acceptData;
  bool selected = false;
  int rndVal = Random().nextInt(8 - 0);
  int countVal = 0;
  var selectedIndex = [];
  @override
  Widget build(BuildContext context) {
    
     for(int i=0;i< rndVal+1;i++){
      selectedIndex.add(0);
    }
    queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(25.0), child: HeaderBody()),
        body: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              width: queryData.size.width,
              height: queryData.size.height,
              color: Color(0xff283744),
              // child: FittedBox(
              //     fit: BoxFit.fill,
              //     child: Image(
              //       image: AssetImage("assets/bg.jpg"),
              //     )),
            ),
            Center(
              child: Column(children: <Widget>[
                Container(
                  width: queryData.size.width * .3,
                  height: queryData.size.height * .25,
                  // color: Colors.red,
                  child: Image(
                    image: AssetImage("assets/orange2.png"),
                  ),
                ),
                Container(
                  width: queryData.size.width * .95,
                  height: queryData.size.height * .65,
                  decoration: new BoxDecoration(
                      color: Colors.black26,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0))),
                  // color: Colors.blue,
                  child: Row(
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: queryData.size.width * .48,
                              child: Text(
                                  "Count the fruit and drag the Numbers in the blocks",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                            ),
                            Center(
                              child: Container(
                                  // color: Colors.blue[200],
                                  width: queryData.size.width * .45,
                                  height: queryData.size.height * .55,
                                  // color: Colors.green,
                                  child: GridView.builder(
                                      itemCount: quetionData[rndVal],
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          // onTapUp: onTapUp,
                                          // onTapDown: onTapDown,
                                          child: CountAnime(index, rndVal,selectedIndex,countVal),
                                        );
                                      })),
                            ),
                          ]),
                      Container(
                        width: queryData.size.width * .002,
                        height: queryData.size.height * .6,
                        color: Colors.grey[700],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          DragTarget(
                            builder: (context, accepted, rejected) => Container(
                                  height: queryData.size.height * .18,
                                  width: queryData.size.width * .12,
                                  // color: Colors.blueGrey[200],
                                  decoration: new BoxDecoration(
                                      color: Colors.blueGrey[200],
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  child: Center(
                                    child: acceptData == null
                                        ? Text("Drag ans here")
                                        : Text("$acceptData",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 50.0)),
                                  ),
                                ),
                            onAccept: (int data) {
                              setState(() {
                                if (data == rndVal + 1) {
                                  acceptData = data;
                                  
                                  print(
                                      "manu matched ....................${rndVal + 1}");
                                  new Future.delayed(
                                      new Duration(milliseconds: 600), () {
                                    setState(() {
                                      acceptData = null;
                                      selectedIndex.clear();
                                      rndVal = Random().nextInt(8 - 0) + 1;
                                    });
                                  });
                                }
                              });
                            },
                          ),
                          Container(
                            height: queryData.size.height * .32,
                            width: queryData.size.width * .45,
                            child: Center(
                              child: new GridView.count(
                                  crossAxisCount: 5,
                                  padding: const EdgeInsets.all(4.0),
                                  children: dragBoxData.map((e) {
                                    return Draggable(
                                      data: e,
                                      dragAnchor: DragAnchor.child,
                                      feedback: Container(
                                        height: queryData.size.height * .16,
                                        width: queryData.size.width * .1,
                                        child: Center(
                                          child: Text(
                                            "$e",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 50.0),
                                          ),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: new GridTile(
                                          child: Card(
                                              color: Colors.red[300],
                                              child: Center(
                                                  child: new Text("$e",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0))))),
                                    );
                                  }).toList()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}
