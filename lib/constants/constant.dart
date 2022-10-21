import 'package:flutter/material.dart';

Color primaryAppColor = Colors.purple;

Uri productByIdUrl(String id, String token) {
  return Uri.parse(
      "https://shop-app-8c977-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token");
}
