import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     description: 'A red tshirt - it is pritty red',
    //     imageUrl:
    //         'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRNe23lD9BuggECnAaEaFNLXsvI_Qrdtqc7Ncvd5CeiLlJ7d6BPZaVBEceWMg&usqp=CAc',
    //     price: 200,
    //     title: 'T-Shirt'),
    // Product(
    //     id: 'p2',
    //     description: 'A red tshirt - it is pritty red',
    //     imageUrl:
    //         'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRNe23lD9BuggECnAaEaFNLXsvI_Qrdtqc7Ncvd5CeiLlJ7d6BPZaVBEceWMg&usqp=CAc',
    //     price: 200,
    //     title: 'T-Shirt'),
    // Product(
    //     id: 'p3',
    //     description: 'A red tshirt - it is pritty red',
    //     imageUrl:
    //         'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRNe23lD9BuggECnAaEaFNLXsvI_Qrdtqc7Ncvd5CeiLlJ7d6BPZaVBEceWMg&usqp=CAc',
    //     price: 200,
    //     title: 'T-Shirt'),
    // Product(
    //     id: 'p4',
    //     description: 'A red tshirt - it is pritty red',
    //     imageUrl:
    //         'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRNe23lD9BuggECnAaEaFNLXsvI_Qrdtqc7Ncvd5CeiLlJ7d6BPZaVBEceWMg&usqp=CAc',
    //     price: 200,
    //     title: 'T-Shirt'),
  ];
  // var _showFavouriteOnly = false;

  List<Product> get items {
    // if (_showFavouriteOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get showFavItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void showFavouriteOnly() {
  //   _showFavouriteOnly = true;
  //   notifyListeners();
  // }

  // void showAllOnly() {
  //   _showFavouriteOnly = false;
  //   notifyListeners();
  // }

  //Function to find product with given id
  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    const url = 'https://flutter-c99be.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; //Instance of response converted into json and extracted using body
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) {
    const url = 'https://flutter-c99be.firebaseio.com/products.json';
    return http
        .post(
      url,
      body: json.encode({
        //Converting object into json
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite
      }),
    )
        .then((res) {
      final newProduct = Product(
          description: product.description,
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(res.body)['name']); //ID or name from the server
      _items.add(newProduct);
      notifyListeners();
    }).catchError((onError) {
      print(onError);
      throw onError; // sends the error to the user screen
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = 'https://flutter-c99be.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('Error');
    }
  }

// optimistic delete product

  void deleteProduct(String id) {
    final url = 'https://flutter-c99be.firebaseio.com/products/$id.json';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    http.delete(url).then((_) => existingProduct = null).catchError(
          (_) => _items.insert(existingProductIndex, existingProduct),
        );
    notifyListeners();
  }
}
