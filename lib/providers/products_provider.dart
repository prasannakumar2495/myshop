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

  final url = Uri.parse(
    'https://myshop-838c2-default-rtdb.firebaseio.com/products.json',
  );

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

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
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
            isFavorite: value['isFavorite'],
          ),
        );
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      rethrow;
    }
  }

  //https://cdn.pixabay.com/photo/2015/10/27/08/51/autumn-1008520__480.png
  //https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387__480.png
  //https://cdn.pixabay.com/photo/2017/03/06/14/44/stary-2121647__480.png
  //https://cdn.pixabay.com/photo/2017/05/20/13/08/horse-2328891__480.png
  //https://cdn.pixabay.com/photo/2017/02/04/22/37/panther-2038656__480.png
  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
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
      'https://myshop-838c2-default-rtdb.firebaseio.com/products/$id.json',
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
      'https://myshop-838c2-default-rtdb.firebaseio.com/products/$id.json',
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
