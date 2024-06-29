import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:order_list_product_create/controler/product_listing_controller.dart';
import 'package:order_list_product_create/utils/global_variables.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    calculateBill();
  }

  void calculateBill() {
    context.read<ProductListingController>().calculateTotalBill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Cart",
          style: heading3,
        ),
      ),
      body: Consumer<ProductListingController>(
        builder: (context, providerValue, child) {
          return providerValue.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: primaryColor,
                ))
              : providerValue.cartItems.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/cart.png',
                            scale: 1.6,
                            color: Colors.white,
                          ),
                          Text(
                            "YOUR CART IS EMPTY",
                            style: des2,
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: providerValue.cartItems.map((item) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: boxColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name ?? "",
                                              style: heading2,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Rs. 500",
                                              style: heading2,
                                            ),
                                            if (item.price?.length != null) ...[
                                              SizedBox(height: 10),
                                              Text(
                                                "SIZE",
                                                style: des2,
                                              ),
                                              SizedBox(height: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    item.price!.map((price) {
                                                  return Visibility(
                                                    visible:
                                                        price.isAdded ?? false,
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                          value:
                                                              price.isAdded ??
                                                                  false,
                                                          onChanged: (value) {},
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${price.name} (${price.price})",
                                                              style: des2,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                            if (item.extras != null) ...[
                                              SizedBox(height: 10),
                                              Text(
                                                "EXTRAS",
                                                style: des2,
                                              ),
                                              SizedBox(height: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    item.extras!.map((extra) {
                                                  return Visibility(
                                                    visible:
                                                        extra.isAdded ?? false,
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                          value:
                                                              extra.isAdded ??
                                                                  false,
                                                          onChanged: (value) {
                                                            providerValue.selectExtra(
                                                                index: providerValue
                                                                    .cartItems
                                                                    .indexOf(
                                                                        item),
                                                                extraIdx: item
                                                                    .extras!
                                                                    .indexOf(
                                                                        extra));
                                                          },
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${extra.name} (${extra.price})",
                                                              style: des2,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        color: primaryColor,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Consumer<ProductListingController>(
                                              builder: (context, providerValue,
                                                  child) {
                                                var quantity = item.quantity;
                                                return Text(
                                                  " ${quantity == 0 ? 'QTY' : '$quantity'} ",
                                                  style: button,
                                                );
                                              },
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        if (providerValue.cartItems.isNotEmpty)
                          Container(
                            color: borderColor,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Bill",
                                      style: heading2,
                                    ),
                                    Text(
                                      providerValue.totalBill.toString(),
                                      style: heading2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              borderColor),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "+ ADD MORE ITEMS",
                                      style: heading2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      bool? res =
                                          await providerValue.addOrder();
                                      if (res == true) {
                                        const snackBar = SnackBar(
                                          content: Text(
                                              "Your order has been placed."),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.pop(context);
                                      }
                                      if (res == false) {
                                        const snackBar = SnackBar(
                                          content: Text(
                                              'Something went wrong with your order.'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "PLACE ORDER",
                                      style: heading2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
        },
      ),
    );
  }
}
