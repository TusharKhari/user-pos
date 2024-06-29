import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_list_product_create/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListingController extends ChangeNotifier {
  int pageIndex = 0;
  void changePageIndex({required int idx}) {
    pageIndex = idx;
    notifyListeners();
  }

  List<ProductModel> productsList = [];
  Future<void> getProducts({required int tableNo}) async {
    productsList.clear();
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

  void selectExtra(
      {required int index, required int extraIdx, required bool val}) {
    for (int i = 0; i < (productsList[index].extras?.length ?? 0); i++) {
      if (i == extraIdx) {
        var extras = productsList[index].extras?[i].copyWith(isAdded: val);
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
    // is all size false

    bool isAllSizeFalse = true;
    for (NamePriceIsAdded p in cam.price ?? []) {
      if (p.isAdded == true) {
        isAllSizeFalse = false;
        break;
      }
    }
    if (isAllSizeFalse) {
      throw "Size not selected.";
    }
    //
    if (cam.quantity == 0) {
      throw "Please increase quantity.";
    }
    // add to list
    var cItem = cam.copyWith(totalPrice: _calculatePriceOfParticularItem(cam));
    cartItems.add(cItem);
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

  double _calculatePriceOfParticularItem(ProductModel item) {
    double totalPrice = 0;
    for (NamePriceIsAdded price in item.price ?? []) {
      if (price.isAdded == true) {
        totalPrice += double.parse("${item.quantity ?? "0"}") *
            double.parse(price.price ?? "0");
      }
    }
    for (NamePriceIsAdded extra in item.extras ?? []) {
      if (extra.isAdded == true) {
        totalPrice += double.parse("${item.quantity ?? "0"}") *
            double.parse(extra.price ?? "0");
      }
    }
    return totalPrice;
  }

  void increaseQuantityInCart({required int index}) {
    cartItems[index] = cartItems[index].copyWith(
      quantity: (cartItems[index].quantity ?? 0) + 1,
    );
    cartItems[index] = cartItems[index].copyWith(
        totalPrice: _calculatePriceOfParticularItem(cartItems[index]));
    calculateTotalBill();
    notifyListeners();
  }

  void decreaseQuantityInCart({required int index}) {
    cartItems[index] = cartItems[index].copyWith(
      quantity: (cartItems[index].quantity ?? 0) - 1,
    );
    cartItems[index] = cartItems[index].copyWith(
        totalPrice: _calculatePriceOfParticularItem(cartItems[index]));
    if (cartItems[index].quantity == 0) {
      cartItems.removeAt(index);
    }
    calculateTotalBill();
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
      List<String> orderIds = [];
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
        await order.add(data).then((DocumentReference value) {
          orderIds.add(value.id);
        }).catchError((error) => print("Failed to add user: $error"));
        isLoading = false;
      }
      var sharedPref = await SharedPreferences.getInstance();
      var yrL = sharedPref.getStringList("orderIds") ?? [];
      await sharedPref.setStringList("orderIds", [...orderIds, ...yrL]); 
      log("logOrderIds $orderIds");
      orderIds.clear();
      cartItems.clear();
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("_addProductToFireDbb $e");
    }
  }

  // ========================================================
 List<ProductModel> yourOrderList = [];
  Future<void> getYourOrders() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var orderIds = sharedPrefs.getStringList("orderIds") ?? ["AoTW6eBibUGsTVHXnVZ3", "navsrqZAcvq8vxaoAn2c"];
    log("orderIds $orderIds");
    Stream collectionStream =
        FirebaseFirestore.instance.collection('orders').snapshots();
    collectionStream.listen(
      (event) {
        var querySnapshots = event as QuerySnapshot<Map<String, dynamic>>;
       List<QueryDocumentSnapshot> ordersSnapShots = querySnapshots.docs;
      
       for (var element in ordersSnapShots) {
         if(orderIds.any((ele) {
           return element.id == ele;
         },)) {
           var json = element.data() as Map<String, dynamic>;
          var d = ProductModel.fromJson(json);
          yourOrderList.add(d);
         }
       }
       notifyListeners();
          log("your orders ---> $yourOrderList");
      },
    );
  }
}
