// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PortfolioProvider extends ChangeNotifier {
  List<dynamic> products = [];
  int? productQuantity;

  Future<void> fetchportfolioProducts() async {
     var headers = {
    'Authorization': 'e7d0224e-8282-48b6-b90c-33d6a3ccd66b',
  };
    final url = Uri.parse(
        'https://yntnedclb9.execute-api.us-east-1.amazonaws.com/dev/users/57/products');
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        products = data['data'];
        notifyListeners();
      } else {
        print('Error: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('SocketException: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  }

}
