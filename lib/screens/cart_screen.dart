import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:order_list_product_create/controler/product_listing_controller.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    calculateBill();
    super.initState();
  }

  void calculateBill() {
    context.read<ProductListingController>().calculateTotalBill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<ProductListingController>(
          builder: (context, providerValue, child) {
        return TextButton(
            onPressed: () async {
              bool? res = await providerValue.addOrder();
               if (res == true) {
                const snackBar =
                    SnackBar(content: Text("Your order has been placed."));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              }
              if (res == false) {
                const snackBar = SnackBar(
                    content: Text('Something went wrong with your order.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Text("Place Order for ${providerValue.totalBill}"));
      }),
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProductListingController>(
              builder: (context, providerValue, child) {
                return providerValue.isLoading
                    ? const CircularProgressIndicator()
                    : ListView.builder(
                        itemCount: providerValue.cartItems.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var item = providerValue.cartItems[index];
                          return GestureDetector(
                            onLongPress: () {
                              providerValue.removeFromCart(index: index);
                            },
                            child: Card(
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
                                const Text("price"),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: item.price?.length ?? 0,
                                  itemBuilder: (context, priceIdx) {
                                    var price = item.price?[priceIdx];
                                    return Visibility(
                                      visible: price?.isAdded ?? false,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: price?.isAdded ?? false,
                                            onChanged: (value) {
                                              // providerValue.selectPrice(
                                              //     index: index, priceIdex: priceIdx);
                                            },
                                          ),
                                          Column(
                                            children: [
                                              Text("${price?.name}"),
                                              Text("${price?.price}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const Text("extras"),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: item.extras?.length ?? 0,
                                  itemBuilder: (context, extraIdx) {
                                    var extra = item.extras?[extraIdx];
                                    return Visibility(
                                      visible: extra?.isAdded ?? false,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: extra?.isAdded ?? false,
                                            onChanged: (value) {
                                              providerValue.selectExtra(
                                                  index: index,
                                                  extraIdx: extraIdx);
                                            },
                                          ),
                                          Column(
                                            children: [
                                              Text("${extra?.name}"),
                                              Text("${extra?.price}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Text("QTY : ${item.quantity}"),
                              ],
                            )),
                          );
                        },
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
