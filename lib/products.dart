// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Products with ChangeNotifier {
  List<Product> productsList = [];
//////
  /*

  void add(
      {required String id,
      required String title,
      required String description,
      required double price,
      required String imageUrl}) {
    final String url =
        "https://flutter-fireb102-default-rtdb.europe-west1.firebasedatabase.app/product.json";
    http.post(Uri.parse(url),
        body: json.encode({
          "id": id,
          "title": title,
          "description": description,
          "price": price,
          "imageurl": imageUrl,
        }));

    productsList.add(Product(
      id: id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
    ));
    print(imageUrl);
    notifyListeners();
  }

  void delete(String id) {
    productsList.removeWhere((element) => element.id == id);
  }*/
////

  Future<void> fetchData() async {
    const url =
        "https://flutter-fireb102-default-rtdb.europe-west1.firebasedatabase.app/product.json";
    try {
      final http.Response res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        final prodIndex =
            productsList.indexWhere((element) => element.id == prodId);
        if (prodIndex >= 0) {
          productsList[prodIndex] = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          );
        } else {
          productsList.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          ));
        }
      });

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateData(String id) async {
    final url =
        "https://flutter-fireb102-default-rtdb.europe-west1.firebasedatabase.app/product/$id.json";

    final prodIndex = productsList.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      await http.patch(Uri.parse(url),
          body: json.encode({
            "title": "new title 4",
            "description": "new description 2",
            "price": 199.8,
            "imageUrl":
                "https://cdn.pixabay.com/photo/2015/06/19/21/24/the-road-815297__340.jpg",
          }));

      productsList[prodIndex] = Product(
        id: id,
        title: "new title ",
        description: "new description ",
        price: 199.8,
        imageUrl:
            "https://cdn.pixabay.com/photo/2015/06/19/21/24/the-road-815297__340.jpg",
      );

      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> add(
      { String id = "",
      String title = "",
      String description = "",
      double price = 0,
      String imageUrl = "", }) async {
    try {
      const url =
        "https://flutter-fireb102-default-rtdb.europe-west1.firebasedatabase.app/product.json";
    
      http.Response res = await http.post(Uri.parse(url),
          body: json.encode({
            "title": title,
            "description": description,
            "price": price,
            "imageUrl": imageUrl,
          }));
      print(json.decode(res.body));

      productsList.add(Product(
        id: json.decode(res.body)['name'],
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
      ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    final url =
        "https://flutter-fireb102-default-rtdb.europe-west1.firebasedatabase.app/product/$id.json";

    final prodIndex = productsList.indexWhere((element) => element.id==id);
    Product? prodItem = productsList[prodIndex];
    productsList.removeAt(prodIndex);
    notifyListeners();

    var res = await http.delete(Uri.parse(url));
    if (res.statusCode >= 400) {
      productsList.insert(prodIndex, prodItem);
      notifyListeners();
      print("Could not deleted item");
    } else {
      prodItem = null;
      print("Item deleted");
    }
  }
}
