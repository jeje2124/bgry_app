import 'dart:convert' as convert;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CallApi {
  // final String _url = 'http://127.0.0.1:8000/api/';
  final String _url = 'http://192.168.1.166:8000/api/';

  postData(data, apiUrl) async {
    final String fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json; charset=UTF-8'
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  updateData(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http
        .put(Uri.parse(fullUrl), body: convert.jsonEncode(data), headers: {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json; charset=UTF-8'
    });
  }

  addData(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // var token = localStorage.getString('token');

    var fullUrl = _url + apiUrl;
    return await http.post(
      Uri.parse(fullUrl),
      body: convert.jsonEncode(data),
      headers: {
        // 'Authorization': 'Bearer $token',
        'Content-type': 'application/json; charset=UTF-8'
      },
    );
  }
}
