import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'athlets_form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyZdvD4qSE2BBUtZ6oMX_BXSwN8urbiHhIFkKdFGf3qpj5aKmo/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      AthletsForm feedbackForm, void Function(String) callback) async {
    try {
      await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  /// Async function which loads feedback from endpoint URL and returns List.
  Future<List<AthletsForm>> getFeedbackList() async {
    return await http.get(URL).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      var sp = jsonFeedback.map((json) => AthletsForm.fromJson(json)).toList();
//      var it = sp.length;
//      print("${sp[2].id}");
//      print('Количество спортсменов в списке = $it');
      return sp;
    });
  }

  void getData() async {
    http.Response response = await http.get(URL);
    if (response.statusCode == 200) {
      var data = response.body;

//      var name = convert.jsonDecode(data)[0]['name'];
//      print(data);

      // TODO: РїРѕР»СѓС‡РёС‚СЊ Р»РёСЃС‚ РѕС„ _suggestions РєР°Рє Р»РёСЃС‚ РѕС„ names ..

//      final _suggestions = convert.jsonDecode(data)[0]['name'];

      // TODO: РїРѕР»СѓС‡РёС‚СЊ Р»РёСЃС‚ РѕС„ names ..

      //  var lenghth = convert.jsonDecode(data.length.toString());
      //  print(lenghth);
    } else {
      print(response.statusCode);
    }
  }
}
