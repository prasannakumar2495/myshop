import 'dart:convert';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  var _showFavoritesOnly = false;
  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    /**
     * this method is used to fetch the products list in ther database to the application.
     */
    final url = Uri.parse(
        'https://myshop-1f07e-default-rtdb.firebaseio.com/products.json');
    http.get(url);
  }

/*
 * we have converted the output type to Future, so that we can add the loading image while the http request is being sent to the webserver.
 */
  Future<void> addProduct(Product product) async {
    /** it doesn't matter if the http request code is written first or at the last, as the server takes time to execute the code. but during this time, the application will not stop funtioning. */
    final url = Uri.parse(
        'https://myshop-1f07e-default-rtdb.firebaseio.com/products.json');
    /**
     * we have added /products at the end of the url, so that the data base will create a  new folder naming it as products. we have also added .json at the end, which is a firebase mandatory to url.
     */
    try {
      final response = await http.post(
        url,
        /**
       * to post data into server, the data should be converted into .json format. we are converting the data into .json format by using the convert import.
       */
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProduct = Product(
        //id: DateTime.now().toString(),
        id: json.encode(response.body),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
    /**
     * the code below will execute only when the above has been executed, as we have implemented 'await' keyword.
     */
    /**
     * the below action will happen only after the posting of the data into the firebase is finished.
     * the data below is now fetched from the firebase.
     * As we have added the "await" key word, there is no need of using the 'then' and 'catch'.
    
        .then(
      (response) { */
    /** this will print the unique ID that has been created by the firebase. 

    print(json.encode(response.body));
    final newProduct = Product(
      //id: DateTime.now().toString(),
      id: json.encode(response.body),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    notifyListeners();*/
    /**},
      
       * in the below code we are going to catch any error after the "then" & "post" code is also execuded.
       
    ).catchError(
      (error) {
        print(error);
        throw (error);
      },
    );*/

    /** this is alternative way of adding the data into _items.
     * _items.insert(0, newProduct);
    */

    // the below will be used to notify all the listeners when there is a change.
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else
      print('...');
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
