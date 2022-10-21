import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  final dynamic _authToken;
  final dynamic _userId;

  Products(this._authToken, this._userId, this._items);

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

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        'https://shop-app-8c977-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$_authToken&$filterString');
    try {
      final response = await http.get(url);
      List<Product> loadProducts = [];
      final data = json.decode(response.body);

      final favUrl = Uri.parse(
          "https://shop-app-8c977-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$_userId.json?auth=$_authToken");

      final favResponse = await http.get(favUrl);

      final favData = json.decode(favResponse.body);

      if (data != null) {
        final extractedData = data as Map<String, dynamic>;
        extractedData.forEach(
          (prodId, prodData) {
            loadProducts.insert(
              0,
              Product(
                id: prodId,
                title: prodData['title'],
                description: prodData['description'],
                price: prodData['price'],
                isFavorite: favData == null ? false : favData[prodId] ?? false,
                imageUrl: prodData['imageUrl'],
              ),
            );
          },
        );
      }
      _items = loadProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-8c977-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$_authToken&orderBy="creatorId"&equalTo="$_userId"');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': _userId,
          },
        ),
      );
      _items.insert(
        0,
        Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = productByIdUrl(id, _authToken);
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
              'creatorId': _userId,
            },
          ),
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    final url = productByIdUrl(id, _authToken);
    final existingIndex = _items.indexWhere((prod) => prod.id == id);
    dynamic existingProduct = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();

    //delete..........................
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
  }
}
