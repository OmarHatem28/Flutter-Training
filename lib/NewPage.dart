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
  Future<APIResponse> results;

  @override
  void initState() {
    super.initState();
    results = getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("New Design"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 300.0,
            child: FutureBuilder<APIResponse>(
              future: results,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildSwiper(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwiper(APIResponse results) {
    return new Swiper(
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 15,
                child: new Image.network(
                  results.characters[index].image,
                  fit: BoxFit.contain,
                  scale: 0.5,
                ),
              ),
              Expanded(
                child: Text(results.characters[index].name),
              ),
            ],
          ),
        );
      },
      itemCount: 15,
      viewportFraction: 0.8,
      scale: 0.9,
    );
  }

  Future<APIResponse> getCharacters() async {
    final response = await http
        .get('https://rickandmortyapi.com/api/character/?page=$pageNo');
    if ( response.statusCode == 200 ){
      return APIResponse.fromJson(jsonDecode(response.body));
    } else {
      showMessage("Check Your Internet Connection!!", _scaffoldKey);
      throw Exception("Check Your Internet Connection");
    }
  }
}
