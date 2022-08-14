import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../model/form_model.dart';

class FormController {
  // Google App Script Web URL
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxOGJn_OPLle29ae2KUI70g4sJ6ZJI6J20cwFmg8YqNdVr5l1xgpVx9sE4FqOuDD3Sc/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void submitForm(FormModel formModel, void Function(String) callback) async {
    try {
      await http.post(URL, body: formModel.toJson()).then((response) async {
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
}
