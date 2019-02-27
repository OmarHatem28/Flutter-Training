import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Widget _buildSuggestions() {
    return ListView.builder(itemBuilder: (context, i) {
      if ( i.isOdd ) return Divider();
      
      final index = i~/2;
      if ( index >= _suggestions.length ){
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
    }, padding: const EdgeInsets.all(16.0),);
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

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute (
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
            final List<Widget> divided = ListTile
                .divideTiles(
                context: context,
                tiles: tiles,
            ).toList();
            return new Scaffold(
              appBar: new AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: new ListView( children: divided ),
              bottomNavigationBar: IconButton(icon: Icon(Icons.accessibility), onPressed: () async {
                final facebookLogin = FacebookLogin();
                final result = await facebookLogin.logInWithReadPermissions(['email','user_gender']);

                switch (result.status) {
                  case FacebookLoginStatus.loggedIn:
                    final token = result.accessToken.token;
                    final graphResponse = await http.get(
                        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
                    final profile = json.decode(graphResponse.body);
                    print(profile["email"]);
                    break;
                  case FacebookLoginStatus.cancelledByUser:
                    print('CANCELED BY USER');
                    break;
                  case FacebookLoginStatus.error:
                    print(result.errorMessage);
                    break;
                }
              }),
            );
          },
      ),
    );
  }

}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
