import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  HttpException _returnToOldFavoriteStatus(bool oldStatus) {
    isFavorite = oldStatus;
    notifyListeners();
    return throw HttpException('Error: Could not change favorite status...');
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final url =
        'https://dat-flutter-shop-app.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        _returnToOldFavoriteStatus(oldStatus);
      }
    } catch (error) {
      _returnToOldFavoriteStatus(oldStatus);
    }
  }
}
