// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//class WordPair {
//  /// The first part of the pair.
//  final String first;
//
//  /// The second part of the pair.
//  final String second;
//
//  String _asPascalCase;
//
//  String _asCamelCase;
//
//  String _asLowerCase;
//
//  String _asUpperCase;
//
//  String _asString;
//
//  /// Create a [WordPair] from the strings [first] and [second].
//  WordPair(this.first, this.second) {
//    if (first == null || second == null) {
//      throw ArgumentError("Words of WordPair cannot be null. "
//          "Received: '$first', '$second'");
//    }
//    if (first.isEmpty || second.isEmpty) {
//      throw ArgumentError("Words of WordPair cannot be empty. "
//          "Received: '$first', '$second'");
//    }
//  }
//
//  /// Creates a single [WordPair] randomly. Takes the same parameters as
//  /// [generateWordPairs].
//  ///
//  /// If you need more than one word pair, this constructor will be inefficient.
//  /// Get an iterable of random word pairs instead by calling
//  /// [generateWordPairs].
//  factory WordPair.random(
//      {int maxSyllables = maxSyllablesDefault,
//      int top = topDefault,
//      bool safeOnly = safeOnlyDefault,
//      Random random}) {
//    random ??= _random;
//    final pairsIterable = generateWordPairs(
//        maxSyllables: maxSyllables,
//        top: top,
//        safeOnly: safeOnly,
//        random: random);
//    return pairsIterable.first;
//  }
//
//  /// Returns the word pair as a simple string, with second word capitalized,
//  /// like `"keyFrame"` or `"franceLand"`. This is informally called
//  /// "camel case".
//  String get asCamelCase => _asCamelCase ??= _createCamelCase();
//
//  /// Returns the word pair as a simple string, in lower case,
//  /// like `"keyframe"` or `"franceland"`.
//  String get asLowerCase => _asLowerCase ??= asString.toLowerCase();
//
//  /// Returns the word pair as a simple string, with each word capitalized,
//  /// like `"KeyFrame"` or `"BigUsa"`. This is informally called "pascal case".
//  String get asPascalCase => _asPascalCase ??= _createPascalCase();
//
//  /// Returns the word pair as a simple string, like `"keyframe"`
//  /// or `"bigFrance"`.
//  String get asString => _asString ??= '$first$second';
//
//  /// Returns the word pair as a simple string, in upper case,
//  /// like `"KEYFRAME"` or `"FRANCELAND"`.
//  String get asUpperCase => _asUpperCase ??= asString.toUpperCase();
//
//  @override
//  int get hashCode => asString.hashCode;
//
//  @override
//  bool operator ==(Object other) {
//    if (other is WordPair) {
//      return first == other.first && second == other.second;
//    } else {
//      return false;
//    }
//  }
//
//  /// Returns a string representation of the [WordPair] where the two parts
//  /// are joined by [separator].
//  ///
//  /// For example, `new WordPair('mine', 'craft').join()` returns `minecraft`.
//  String join([String separator = '']) => '$first$separator$second';
//
//  /// Creates a new [WordPair] with both parts in lower case.
//  WordPair toLowerCase() => WordPair(first.toLowerCase(), second.toLowerCase());
//
//  @override
//  String toString() => asString;
//
//  String _capitalize(String word) {
//    return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
//  }
//
//  String _createCamelCase() => "${first.toLowerCase()}${_capitalize(second)}";
//
//  String _createPascalCase() => "${_capitalize(first)}${_capitalize(second)}";
//}

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
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
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
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
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
