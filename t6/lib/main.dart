// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:treinerId/athlets_form.dart';
import 'web_matters.dart';

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

class RandomWordsState extends State<RandomWords> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  var athlets;
  final _saved = [];
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
// @f ну поехали, пытаемся всместо списка получить список с web

//    FormController().getData();
    FormController().getFeedbackList().then((feedbackItems) {
      this.athlets = feedbackItems;

      setState(() {
        this.athlets = feedbackItems;
      });
    });
//    var it = athlets.length;
//    print("${athlets[2].id}");
//    print('спортсменов с списке web = $it');

    // @f ну поехали, пытаемся всместо списка получить список с web

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: athlets.length,
        itemBuilder: /*1*/ (context, i) {
          //if (i.isOdd) return Divider(); /*2*/

          final index = i; /*3*/
//          if (index >= athlets.length) {
//            athlets.addAll;
//          } /*4*/
//
//            //           _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//          }
          String row = athlets[index].name;
          return _buildRow(row);
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
          IconButton(
            icon: Icon(Icons.list),
            tooltip: 'Список присутствующих сегодня',
            onPressed: _pushSaved,
          ),
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
          print(_saved);
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
//            bottomNavigationBar: BottomAppBar(
//              color: Colors.pink,
//              child: Text(
//                'отправить',
//                style: _biggerFont,
//              ),
//            ),
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.alternate_email),
                  tooltip: 'Отправить всех в облако',
                  onPressed: () {
                    submit(_saved);
                  },
                ),
              ],
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
//final _formKey = GlobalKey<FormState>();
//final _scaffoldKey = GlobalKey<ScaffoldState>();
//// Method to show snackbar with 'message'.
//_showSnackbar(String message) {
//  final snackBar = SnackBar(content: Text(message));
//  _scaffoldKey.currentState.showSnackBar(snackBar);
//}

// функция отправки одной строки
void submit(saved) {
  //print(_saved[1]);
  // Validate returns true if the form is valid, or false
  // otherwise.

  // If the form is valid, proceed.
  Today today = Today(saved[0]);

  FormController formController = FormController();

  //_showSnackbar("Данные отправляюся");

  // Submit 'feedbackForm' and save it in Google Sheets.
  formController.submitForm(today, (String response) {
    print("Response: $response");
    if (response == FormController.STATUS_SUCCESS) {
      // Feedback is saved succesfully in Google Sheets.
      print('1 спортсмен отправлен');
      //_showSnackbar("Список отправлен");
    } else {
      // Error Occurred while saving data in Google Sheets.
      // _showSnackbar("Что-то не так!");
      print("Что-то не так!");
    }
  });
}

void main() => runApp(MyApp());
