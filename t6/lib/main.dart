// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//import 'dart:math';
import 'package:flutter/material.dart';
//import 'package:english_words/english_words.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // скрываем надпись debug
      title: 'Дневник тренера ПКУ',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class Athlets {
  String name;
  int unit;
  int id;

  Athlets({this.name, this.unit, this.id});
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = [
    'Шиябов Ильхам',
    'Черепенников Даниио',
    'Петрин Арсений',
    'Айдимиров Александр',
    'Софронов Сергей',
    'Мигунов Илья',
    'Водолазов Антон',
    'Аношин Данил',
    'Киндеев Максим',
    'Лысов Пётр',
    'Мельников Сергей',
    'Першко Владислав',
    'Плахов Святослав',
    'Турищев Ярослав',
    'Шмыков Егор'
  ];
  final _saved = [];
  // final Set<String> _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _suggestions.length,
        itemBuilder: /*1*/ (context, i) {
          //if (i.isOdd) return Divider(); /*2*/

          final index = i; /*3*/
//          if (index >= _suggestions.length) {
//            _suggestions.addAll; /*4*/
//
//            //           _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//          }
          return _buildRow(_suggestions[index]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.accessibility_new : Icons.accessible,
        color: alreadySaved ? Colors.green : null,
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
  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Общий список'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  // #enddocregion RWS-build

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Тренируются сегодня'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
// #docregion RWS-var
}
// #enddocregion RWS-var

void main() => runApp(MyApp());
