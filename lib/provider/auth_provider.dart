import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiredate;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiredate != null &&
        _expiredate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token as String;
    }
    return null;
  }

  static const params = {'key': 'AIzaSyBT0QsMq0eHhO75OiuHViTE81P5CvDviGM'};

  Future<void> Authenticate(
      String email, String password, String modifier) async {
    try {
      var url = Uri.https(
          'identitytoolkit.googleapis.com', '/v1/accounts:$modifier', params);
      var result = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final resultData = json.decode(result.body);
      print(result.body);

      if (resultData['error'] != null) {
        print(resultData['error'] != null);
        throw (resultData['error']['message']);
      }
      _token = resultData['idToken'];
      _userId = resultData['localId'];
      _expiredate = DateTime.now()
          .add(Duration(seconds: int.parse(resultData['expiresIn'])));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

//user register method
  Future<void> Signup(String email, String password) async {
    return Authenticate(email, password, 'signUp');
  }

//user login method
  Future<void> Login(String email, String password) async {
    return Authenticate(email, password, 'signInWithPassword');
  }
}
