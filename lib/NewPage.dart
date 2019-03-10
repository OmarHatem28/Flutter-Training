import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'main.dart';
import 'Models/APIResponse.dart';


class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewPageState();
}

class NewPageState extends State<NewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var rand = new Random();
  var number=0;
  var pageNo = 1;


  @override
  Widget build(BuildContext context) {

    getCharacters();

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
                        pageNo++;
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

  getCharacters() async {
    final waitMe = await http.get('https://rickandmortyapi.com/api/character/?page=${pageNo}');
    Map charMap = jsonDecode(waitMe.body);
    var response = APIResponse.fromJson(charMap);
    showMessage(response.characters[0].name, _scaffoldKey);

    return waitMe;
  }
  
}