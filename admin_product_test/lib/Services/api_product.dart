import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/model/product_model.dart';

class ApiProduct{
  static Future<List<Product>> getProduct() async {
    List<Product> productList = [];

    QuerySnapshot snapshot = await Firestore.instance
      .collection('product')
      .getDocuments();

    snapshot.documents.forEach((element) { 
      Product product = Product.fromMap(element.data);
      productList.add(product);
    });
  }
}