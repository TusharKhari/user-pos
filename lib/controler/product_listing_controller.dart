import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_list_product_create/models/product_model.dart';

class ProductListingController extends ChangeNotifier {
  List<ProductModel> productsList = [];
  Future<void> getProducts({required int tableNo}) async {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    var pro = await products.get();
    for (var element in pro.docs) {
      var data = element.data() as Map<String, dynamic>;
      var pro = ProductModel.fromJson(data);
      var pr = pro.copyWith(tableNo: tableNo);
      productsList.add(pr);
    }
    notifyListeners();
  }

  void selectPrice({required int index, required int priceIdex}) {
    for (int i = 0; i < (productsList[index].price?.length ?? 0); i++) {
      if (i == priceIdex) {
        var price = productsList[index].price?[i].copyWith(isAdded: true);
        productsList[index].price?[i] = price!;
      } else {
        var price = productsList[index].price?[i].copyWith(isAdded: false);
        productsList[index].price?[i] = price!;
      }
    }
    notifyListeners();
  }

  void selectExtra({required int index, required int extraIdx}) {
    for (int i = 0; i < (productsList[index].extras?.length ?? 0); i++) {
      if (i == extraIdx) {
        var extras = productsList[index].extras?[i].copyWith(isAdded: true);
        productsList[index].extras?[i] = extras!;
      }
    }
    notifyListeners();
  }

  void increaseQuantity({required int index}) {
    var product = productsList[index];
    var quantity = product.quantity ?? 0;
    var item = product.copyWith(quantity: ++quantity);
    productsList[index] = item;
    log("message ${item.quantity}");
    notifyListeners();
  }

  void decreaseQuantity({required int index}) {
    var product = productsList[index];
    if (product.quantity != 0) {
      var quantity = product.quantity ?? 0;
      var item = product.copyWith(quantity: --quantity);
      productsList[index] = item;
      notifyListeners();
    }
  }

  List<ProductModel> cartItems = [];
  void addItemInCart({required int index}) {
    var cp = productsList[index];
    cp = cp.copyWith(status: 1);
    ProductModel cam = ProductModel.fromJson(cp.toJson());
    cartItems.add(cam);

    // reset values
    var product = productsList[index];
    var item = product.copyWith(quantity: 0);
    productsList[index] = item;
    for (int i = 0; i < (product.extras?.length ?? 0); i++) {
      var extras = productsList[index].extras?[i].copyWith(isAdded: false);
      productsList[index].extras?[i] = extras!;
    }
    for (int i = 0; i < (product.price?.length ?? 0); i++) {
      var price = productsList[index].price?[i].copyWith(isAdded: false);
      productsList[index].price?[i] = price!;
    }
    notifyListeners();
  }

  void removeFromCart({required int index}) {
    cartItems.removeAt(index);
    calculateTotalBill();
    notifyListeners();
  }

  double totalBill = 0;
  void calculateTotalBill() {
    totalBill = 0;
    for (var item in cartItems) {
      for (NamePriceIsAdded price in item.price ?? []) {
        if (price.isAdded == true) {
          totalBill += double.parse("${item.quantity ?? "0"}") *
              double.parse(price.price ?? "0");
        }
      }
      for (NamePriceIsAdded extra in item.extras ?? []) {
        if (extra.isAdded == true) {
          totalBill += double.parse("${item.quantity ?? "0"}") *
              double.parse(extra.price ?? "0");
        }
      }
    }
  }

  bool isLoading = false;
  Future<bool?> addOrder() async {
    if (cartItems.isEmpty) {
      return false;
    }
    try {
      isLoading = true;
      notifyListeners();
      for (var ordr in cartItems) {
        if (ordr.quantity == 0) {
          isLoading = false;
          notifyListeners();
          return false;
        }
        var data = ordr.toJson();
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference order = firestore.collection('orders');
        await order
            .add(data)
            .then((value) => print("order placed"))
            .catchError((error) => print("Failed to add user: $error"));
        isLoading = false;
      }
      cartItems.clear();
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("_addProductToFireDbb $e");
    }
  }
}
