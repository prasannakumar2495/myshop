import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavouriteStatus(
      BuildContext context, String token, String userId) async {
    final favoriteUrl = Uri.parse(
      'https://myshop-838c2-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token',
    );

    isFavorite = !isFavorite;
    notifyListeners();

    await http.put(favoriteUrl, body: json.encode(isFavorite)).then((response) {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (response.statusCode >= 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error making the item as Favourite!'),
          ),
        );
      } else {
        if (isFavorite) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item marked as Favourite!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item removed as Favourite!'),
            ),
          );
        }
      }
    });
  }
}
