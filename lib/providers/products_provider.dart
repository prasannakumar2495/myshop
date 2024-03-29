import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String? authToken;
  final String? userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // } else
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items
        .where(
          (element) => element.isFavorite,
        )
        .toList();
  }

  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  /// Parameters inside the square brackets are optional.
  Future<void> fetchAndSetProducts([
    bool filterByUser = false,
  ]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final url = Uri.parse(
      'https://myshop-838c2-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString',
    );
    final favoriteUrl = Uri.parse(
      'https://myshop-838c2-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken',
    );
    try {
      final response = await http.get(url);
      final favouriteResponse = await http.get(favoriteUrl);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final faouriteData = json.decode(favouriteResponse.body);

      //debugPrint(extractedData.toString());
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: faouriteData == null
                ? false
                : faouriteData[key] ??
                    false, //if the key is also null, then the last false will be used.
          ),
        );
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      'https://myshop-838c2-default-rtdb.firebaseio.com/products.json?auth=$authToken',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      //debugPrint(json.decode(response.body)['name']);
      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final updateUrl = Uri.parse(
      'https://myshop-838c2-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken',
    );

    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      await http.patch(
        updateUrl,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {}
  }

  void deleteProduct(String id, BuildContext context) {
    final deleteUrl = Uri.parse(
      'https://myshop-838c2-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken',
    );
    //_items.removeWhere((element) => element.id == id);
    /**
     * For Delete request we cannot catch the errors, so code will not move to catchError block.
     * So, we have to use the error codes that we recive from server.
     */
    ScaffoldMessenger.of(context).clearSnackBars();
    http.delete(deleteUrl).then((response) {
      if (response.statusCode >= 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item Not Deleted!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item Deleted!'),
            duration: Duration(seconds: 2),
          ),
        );
        fetchAndSetProducts();
      }
    });
    // .catchError((error) {
    //   debugPrint(error.toString());
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Item Not Deleted!'),
    //       duration: Duration(seconds: 2),
    //     ),
    //   );
    // });

    notifyListeners();
  }
}
