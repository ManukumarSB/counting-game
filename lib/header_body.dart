import 'package:flutter/material.dart';

class HeaderBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    // TODO: implement build
    return Container(
     height: queryData.size.height * .08,
      color: Colors.grey[700],
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          Container(
            height: queryData.size.height * .04,
            width: queryData.size.width * .08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.black,
            ),
            child: Center(
                child: Text(
              "Free choice",
              style: TextStyle(color: Colors.white),
            )),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0),
              height: queryData.size.height * .04,
            width: queryData.size.width * .08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.black,
            ),
            child: Center(
                child: Text(
              "Counting",
              style: TextStyle(color: Colors.white),
            )),
          ),
        ],
      ),
    );
  }
}
