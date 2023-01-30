import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/http_exception.dart';

class Auth with ChangeNotifier {
  Future<void> authenticateUser(
      String emailAddress, String password, String requiredMethod) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:${requiredMethod}?key=AIzaSyCg4tZN9ctvHap69gq3yVqxEB-vY2Yk51w');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': emailAddress,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      var errorData = json.decode(response.body);
      var errorMessage = errorData['error']['message'] as String;
      if (errorMessage.isNotEmpty) {
        //throw HttpException(errorMessage);
        return Future.error(HttpException(errorMessage));
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> signUpUser(String emailAddress, String password) async {
    /* final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCg4tZN9ctvHap69gq3yVqxEB-vY2Yk51w');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': emailAddress,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(response.body);
    */
    return authenticateUser(emailAddress, password, 'signUp');
  }

  Future<void> loginUser(String emailAddress, String password) async {
    /* final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCg4tZN9ctvHap69gq3yVqxEB-vY2Yk51w');
    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            'email': emailAddress,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      var errorData = json.decode(response.body);
      var errorMessage = errorData['error']['message'] as String;
      if (errorMessage.isNotEmpty) {
        throw HttpException(errorMessage);
      }
    } catch (error) {
      throw error.toString();
    } */

    return authenticateUser(emailAddress, password, 'signInWithPassword');
  }
}
