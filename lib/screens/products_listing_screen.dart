 
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:image_network/image_network.dart';
import 'package:order_list_product_create/controler/product_listing_controller.dart';
import 'package:order_list_product_create/screens/item_detail.dart';
import 'package:order_list_product_create/utils/global_variables.dart';
import 'package:provider/provider.dart';

import 'dart:js' as js;

import 'package:responsive_framework/responsive_framework.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String? tabNo;
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  void getProducts() {
    String url = js.context['location']['href'].toString();
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
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Menu (${tabNo ?? 0})",
          style: heading2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProductListingController>(
              builder: (context, providerValue, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  clipBehavior: Clip.none,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount:
                          ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                              ? 2
                              : ResponsiveBreakpoints.of(context)
                                      .smallerThan(DESKTOP)
                                  ? 3
                                  : 4),
                  itemCount: providerValue.productsList.length,
                  itemBuilder: (context, index) {
                    var item = providerValue.productsList[index];
                    return Container(
                      decoration: BoxDecoration(
                          color: boxColor,
                          border: Border.all(
                            color: primaryColor,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: ImageNetwork(
                              image: item.photos?.first ?? "",
                              height:
                                  MediaQuery.of(context).size.height * 0.432,
                              width: ResponsiveBreakpoints.of(context)
                                      .smallerThan(TABLET)
                                  ? MediaQuery.of(context).size.width * 0.45
                                  : ResponsiveBreakpoints.of(context)
                                          .smallerThan(DESKTOP)
                                      ? MediaQuery.of(context).size.width * 0.38
                                      : MediaQuery.of(context).size.width *
                                          0.28,
                              fitAndroidIos: BoxFit.contain,
                              fitWeb: BoxFitWeb.contain,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(color: primaryColor),
                              width: double.infinity,
                              height: 35,
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${item.name!.capitalizeFirst ?? ""}  (${item.category!.capitalizeFirst ?? ""})",
                                        style: heading2,
                                        overflow: TextOverflow.ellipsis,
                                      ), 
                                      // Text(
                                      //   item.category!.capitalizeFirst ?? "",
                                      //   style: heading2,
                                      //   overflow: TextOverflow.ellipsis,
                                      // ), 
                                    ],
                                  ), 
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                decoration: BoxDecoration(color: primaryColor),
                                width: double.infinity,
                                height: 40,
                                padding: EdgeInsets.only(left: 10, bottom: 5),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ItemDetailScreen(itemIndex: index),
                                      ));
                                    },
                                    child: Text(
                                      "ADD",
                                      style: heading2,
                                    ))),
                          ),
                        ],
                      ),
                    );
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
