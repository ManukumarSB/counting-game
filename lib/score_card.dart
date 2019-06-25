import 'package:counting/animation2.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatefulWidget {
  ScoreCard({key}) : super(key: key);
  @override
  ScoreCardState createState() {
    return new ScoreCardState();
  }
}

class ScoreCardState extends State<ScoreCard> {
  bool _isPaused = false;
  int inc = 0;
  int inc2 = 100;
  int starCount = 2;
  List<int> starValues = [];
  List<int> starValues2 = [];
  int coinCount = 100;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    for (int i = 1; i <= starCount; i++) {
      starValues..add(0);
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 50.0,
                  child: Center(child: Text("Score card")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: new BoxDecoration(
                          color: Colors.black26,
                          borderRadius: new BorderRadius.all(
                            const Radius.circular(50.0),
                          )),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: new BoxDecoration(
                              color: Colors.black26,
                              borderRadius: new BorderRadius.all(
                                const Radius.circular(50.0),
                              )),
                        ),
                        Container(
                          height: 30.0,
                          width: 100.0,
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 30.0,
                                width: 30.0,
                                // color: Colors.green,
                                child: FlareActor(
                                  "assets/coin.flr",
                                ),
                              ),
                              Text("$coinCount"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        starValues.clear();
                        starValues2.clear();
                        starCount =
                            starCount >= 5 ? starCount = 1 : starCount + 1;
                        MoveContainer(coinCount: coinCount);
                      });
                    },
                    child: Container(
                      height: 200.0,
                      width: 200.0,
                      color: Colors.black26,
                      child: Center(child: Text("manu here")),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                                children: starValues
                                    .map((e) => Padding(
                                        padding: EdgeInsets.all(1.0),
                                        child: _buildItem(
                                          inc++,
                                          e,
                                        )))
                                    .toList(growable: false)),
                          ),
                          // Row(
                          //     children: starValues2
                          //         .map((e) => Padding(
                          //             padding: EdgeInsets.all(1.0),
                          //             child: _buildItem(
                          //               inc2++,
                          //               e,
                          //             )))
                          //         .toList(growable: false)),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Center(child: MoveContainer(coinCount: coinCount))
        ],
      ),
    );
  }

  _buildItem(int inc, int e) {
    return Container(
      height: 150.0,
      width: 110.0,
      // color: Colors.green,
      child: FlareActor(
        "assets/coin.flr",
        // alignment: Alignment.bottomLeft,
        // isPaused: _isPaused,
        animation: e == 1 ? "idle" : "coin",
      ),
    );
  }
}
