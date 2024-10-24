// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  final Map<String, int> _quantities = {}; 

  CategoryProvider() {
    _loadAllQuantitiesFromPrefs();
  }

  int getQuantity(String categoryId) {
    return _quantities[categoryId] ?? 0;
  }

  void increment(String categoryId) async {
    _quantities[categoryId] = getQuantity(categoryId) + 1;
    await _saveQuantityToPrefs(categoryId); 
    notifyListeners();
    _sendQuantityToApi(categoryId, "increment");
  }

  void decrement(String categoryId) async {
    if (getQuantity(categoryId) > 0) {
      _quantities[categoryId] = getQuantity(categoryId) - 1;
      await _saveQuantityToPrefs(categoryId);
      notifyListeners();
      _sendQuantityToApi(categoryId, "decrement");
    }
  }

  Future<void> _saveQuantityToPrefs(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quantity_$categoryId', getQuantity(categoryId)); 
    print('Saved quantity for $categoryId: ${getQuantity(categoryId)}');
  }

  Future<void> _loadQuantityFromPrefs(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    _quantities[categoryId] = prefs.getInt('quantity_$categoryId') ?? 0; 
    print('Loaded quantity for $categoryId: ${_quantities[categoryId]}');
  }

  Future<void> _loadAllQuantitiesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) {
      if (key.startsWith('quantity_')) {
        final categoryId = key.replaceFirst('quantity_', '');
        _quantities[categoryId] = prefs.getInt(key) ?? 0;
        print('Loaded quantity for $categoryId: ${_quantities[categoryId]}');
      }
    });
    notifyListeners();
  }

  Future<void> fetchQuantitiesFromPrefs(List<String> productIds) async {
    for (var id in productIds) {
      await _loadQuantityFromPrefs(id);
    }
    notifyListeners();
  }

  Future<void> _sendQuantityToApi(String categoryId, String action) async {
    var headers = {
      'Authorization': 'e7d0224e-8282-48b6-b90c-33d6a3ccd66b'
    };
    var request = http.Request(
      'PUT',
      Uri.parse('https://yntnedclb9.execute-api.us-east-1.amazonaws.com/dev/users/57/products/${categoryId.toString()}/$action'),
    );

    request.headers.addAll(headers);
    request.body = '{"quantity": ${getQuantity(categoryId)}}';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
