 
 import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:order_list_product_create/controler/product_listing_controller.dart';
import 'package:order_list_product_create/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import 'dart:js' as js;

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
   String? tabNo;
  @override
  void initState() {
    // TODO: implement initState
    getProducts();
    super.initState();
  }

  void getProducts() {
    String url = js.context['location']['href'].toString();
    log("url ---> $url");
    if (url.contains("=")) {
      String tableNo = url.toString().split("=")[1];
      tabNo = tableNo;
      context
          .read<ProductListingController>()
          .getProducts(tableNo: int.parse(tableNo));
    } else {
      context.read<ProductListingController>().getProducts(tableNo: 0);
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items ${tabNo}"),
        actions: [
          Consumer<ProductListingController>(builder: (context, value, child) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ));
              },
              child: Badge(
                  child: Icon(Icons.shopping_cart_sharp),
                  label: Text("${value.cartItems.length}")),
            );
          }),
          SizedBox(
            width: 70,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProductListingController>(
              builder: (context, providerValue, child) {
                return ListView.builder(
                  itemCount: providerValue.productsList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = providerValue.productsList[index];
                    return Card(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            ImageNetwork(
                              image: item.photos?.first ?? "",
                              height: 99,
                              width: 99,
                            ),
                            Column(
                              children: [
                                Text(item.name ?? ""),
                                Text(item.description ?? ""),
                              ],
                            )
                          ],
                        ),
                        Text("price"),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: item.price?.length ?? 0,
                          itemBuilder: (context, priceIdx) {
                            var price = item.price?[priceIdx];
                            return Row(
                              children: [
                                Checkbox(
                                  value: price?.isAdded ?? false,
                                  onChanged: (value) {
                                    providerValue.selectPrice(
                                        index: index, priceIdex: priceIdx);
                                  },
                                ),
                                Column(
                                  children: [
                                    Text("${price?.name}"),
                                    Text("${price?.price}"),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const Text("extras"),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: item.extras?.length ?? 0,
                          itemBuilder: (context, extraIdx) {
                            var extra = item.extras?[extraIdx];
                            return Row(
                              children: [
                                Checkbox(
                                  value: extra?.isAdded ?? false,
                                  onChanged: (value) {
                                    providerValue.selectExtra(
                                        index: index, extraIdx: extraIdx);
                                  },
                                ),
                                Column(
                                  children: [
                                    Text("${extra?.name}"),
                                    Text("${extra?.price}"),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  providerValue.decreaseQuantity(index: index);
                                },
                                icon: Icon(Icons.remove)),
                            item.quantity == 0
                                ? Text("QTY")
                                : Text(" ${item.quantity} "),
                            IconButton(
                                onPressed: () {
                                  providerValue.increaseQuantity(index: index);
                                },
                                icon: Icon(Icons.add)),
                            TextButton(
                                onPressed: () {
                                  providerValue.addItemInCart(index: index);
                                },
                                child: Text(
                                  "Add item to cart",
                                ))
                          ],
                        )
                      ],
                    ));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
