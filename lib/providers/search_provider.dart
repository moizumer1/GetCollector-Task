// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcg_collection_app/providers/quantity_provider.dart';

class SearchProvider extends ChangeNotifier {
  String _searchText = '';
  List<dynamic> _allProducts = [];
  List<dynamic> filteredProducts = [];
  final CategoryProvider categoryProvider = CategoryProvider();

  String get searchText => _searchText;

  void updateSearchText(String text) {
    _searchText = text;
    filterProducts();
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://yntnedclb9.execute-api.us-east-1.amazonaws.com/dev/products');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _allProducts = data['data'];
        filteredProducts = List.from(_allProducts);

        // Convert product IDs to strings to ensure consistency
        List<String> productIds = _allProducts.map((product) => product['id'].toString()).toList();
        await categoryProvider.fetchQuantitiesFromPrefs(productIds);
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

  void filterProducts() {
    if (_searchText.isEmpty) {
      filteredProducts = List.from(_allProducts);
    } else {
      filteredProducts = _allProducts.where((product) {
        final title = product['title'].toLowerCase();
        return title.contains(_searchText.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
