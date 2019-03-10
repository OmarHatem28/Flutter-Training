import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'NewPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.red,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        showMessage(message.toString(), _scaffoldKey);
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        showMessage(message.toString(), _scaffoldKey);
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        showMessage(message.toString(), _scaffoldKey);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
      showMessage(token, _scaffoldKey);
    });
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Widget _buildSuggestions() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
      padding: const EdgeInsets.all(16.0),
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : Colors.black,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget titleRow() {
    return Row(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "A Lake",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Green Space With Water in the middle",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          margin: EdgeInsets.fromLTRB(15.0, 20.0, 0, 0),
        ),
        Container(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.yellow,
              )
            ],
          ),
          margin: EdgeInsets.fromLTRB(40.0, 20.0, 10.0, 0),
        ),
        Container(
          child: Column(
            children: <Widget>[
              Text(
                "28",
              )
            ],
          ),
          margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
        ),
      ],
    );
  }

  Widget buttonsRow() {
    return Row(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Image.asset(
                  "images/facebook_ico.png",
                ),
                onTap: _handleFacebookSignIn,
              ),
              Text(
                "Facebook",
                softWrap: false,
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Image.asset(
                  "images/google_ico.png",
                ),
                onTap: _handleGoogleSignIn,
              ),
              Text(
                "Google",
                softWrap: false,
              ),
            ],
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
            floatingActionButton: Container(
              decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.red),
              child: IconButton(
                  icon: Icon(Icons.navigate_next),
                  highlightColor: Colors.blue,
                  color: Colors.yellow,
                  splashColor: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewPage()),
                    );
                  }),
            ),
            drawer: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Image.asset("images/background.jpg")),
                    ],
                  ),
                  titleRow(),
                  Divider(),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Text(
                      "Sign in With Your Favorite Platform",
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  buttonsRow(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _handleFacebookSignIn() async {
    final facebookLogin = FacebookLogin();
    final result =
        await facebookLogin.logInWithReadPermissions(['email', 'user_gender']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        print(profile);
        showMessage(profile["email"], _scaffoldKey);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('CANCELED BY USER');
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
    Navigator.pop(context);
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn();
      print(_googleSignIn.currentUser.toString());
      showMessage(_googleSignIn.currentUser.displayName, _scaffoldKey);
    } catch (error) {
      print(error);
    }
    Navigator.pop(context);
  }
}

void showMessage(String message, GlobalKey<ScaffoldState> _scaffoldKey,
    [MaterialColor color = Colors.blue]) {
  _scaffoldKey.currentState.showSnackBar(
      new SnackBar(backgroundColor: color, content: new Text(message)));
}



class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
