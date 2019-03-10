import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'main.dart';
import 'Models/APIResponse.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewPageState();
}

class NewPageState extends State<NewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var rand = new Random();
  var number = 0;
  var pageNo = 1;
  var characterImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("New Design"),
      ),
      body: Card(
        child: Column(
            children: <Widget>[
              SizedBox(
                height: 300.0,
                child: buildSwiper(),
              ),
            ],
        ),
      )
    );
  }

  Widget buildSwiper() {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            new Image.network(
              "https://rickandmortyapi.com/api/character/avatar/${index+1}.jpeg",
              fit: BoxFit.contain,
            ),
            Text("Heeloloollo"),
          ],
        );
      },
      itemCount: 15,
      viewportFraction: 0.8,
      scale: 0.9,
    );
  }

  Future<String> getCharacters(int index) async {
    final waitMe = await http
        .get('https://rickandmortyapi.com/api/character/?page=$pageNo');
    Map charMap = jsonDecode(waitMe.body);
    var response = APIResponse.fromJson(charMap);
    showMessage(response.characters[index].image, _scaffoldKey);

    return response.characters[index].image;
  }
}