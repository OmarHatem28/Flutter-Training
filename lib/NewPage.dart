import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';


class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewPageState();
}

class NewPageState extends State<NewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var rand = new Random();
  var number=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("New Design"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Card(
                elevation: 10.0,
                color: Colors.yellow,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "images/background.jpg",
                      height: 100.0,
                      fit: BoxFit.fitHeight,
                    ),
                    IconButton(icon: Icon(Icons.call), onPressed: () {
                      setState(() {
                        number = rand.nextInt(100);
                      });
                    }),
                    Text(number.toString()),
                    SizedBox.fromSize(
                      child: FlatButton(
                          onPressed: () {
                            showMessage("Pressed", _scaffoldKey);
                          },
                          child: Image.asset('images/background.jpg')),
                      size: Size(200.0, 200.0),
                    )
                  ],
                ),
              )
            ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}