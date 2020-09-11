import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:treinerId/athlets_form.dart';
import 'web_matters.dart';

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
  final _saved = ['кадеты'];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SnackBar snackBar = const SnackBar(content: Text('отправлены'));

  Widget _buildSuggestions() {
// @f ну поехали, пытаемся всместо списка получить список с web
    int r = 0;
    int a = 0;
    FormController().getFeedbackList().then((feedbackItems) {
      this.athlets = feedbackItems;

      setState(() {
        //this.athlets = feedbackItems;
      });
    });

    athlets[0].name = 'Кадеты';
    athlets[0].unit = '1';
    athlets[0].id = '1';

    print('длина списка равна $a');
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: athlets.length,
      itemBuilder: (context, i) {
        final index = i;
        String row = athlets[index].name;
        return _buildRow(row);
      },
    );
  }

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

  void _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text("Список присутствующих на тренировке"),
              content: new Text("отправлен"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Принято!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

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
            //       key: scaffoldKey,
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.alternate_email),
                  tooltip: 'Отправить всех в облако',
                  onPressed: () {
                    submit(_saved);
                    _showCupertinoDialog();
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
}

// функция отправки одной строки
void submit(List saved) {
//  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//  final SnackBar snackBar = const SnackBar(content: Text('отправлены'));

  int i = saved.length;
  print('список тренирующихся = $i');

  Today today = Today(saved[0]);

  FormController formController = FormController();

  // Submit 'feedbackForm' and save it in Google Sheets.
  formController.submitForm(today, (String response) {
    print("Response: $response");
    if (response == FormController.STATUS_SUCCESS) {
      //   scaffoldKey.currentState.showSnackBar(snackBar);

      // Feedback is saved succesfully in Google Sheets.
      print('1 спортсмен отправлен');
    } else {
      print("Что-то не так!");
    }
  });
}

void main() => runApp(MyApp());
