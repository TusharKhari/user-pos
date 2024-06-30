import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:order_list_product_create/controler/product_listing_controller.dart';
import 'package:order_list_product_create/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class YourOrdersScreen extends StatefulWidget {
  const YourOrdersScreen({super.key});

  @override
  State<YourOrdersScreen> createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getYourOrders();
    super.initState();
  }

  void getYourOrders() {
    context.read<ProductListingController>().getYourOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Your Orders",
          style: heading3,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProductListingController>(
              builder: (context, providerVal, child) {
                return Column(
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                   Visibility(
                    visible: providerVal.yourOrderList.isNotEmpty,
                     child: Column(
                      children: [ if (providerVal.isAnyPreparing == false &&
                          providerVal.isAllPrepared == false)
                        Container(
                          width: 300,
                          color: borderColor,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.av_timer_sharp,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Your Order is placed",
                                style: heading2,
                              ),
                            ],
                          ),
                        ),
                      if (providerVal.isAnyPreparing)
                        Container(
                          width: 300,
                          color: borderColor,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.av_timer_sharp,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Your Order is being prepared",
                                style: heading2,
                              ),
                            ],
                          ),
                        ),
                      if (providerVal.isAllPrepared)
                        Container(
                          width: 300,
                          color: borderColor,
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.av_timer_sharp,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Your Order is prepared",
                                style: heading2,
                              ),
                            ],
                          ),
                        ),],
                     ),
                   ), 
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: providerVal.yourOrderList.length,
                      itemBuilder: (context, index) {
                        var order = providerVal.yourOrderList[index];
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: borderColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ImageNetwork(
                                        image: order.photos!.first,
                                        height:
                                            ResponsiveBreakpoints.of(context)
                                                    .smallerThan(TABLET)
                                                ? 120
                                                : 150,
                                        width: ResponsiveBreakpoints.of(context)
                                                .smallerThan(TABLET)
                                            ? 120
                                            : 150),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText(
                                                overflow: TextOverflow.ellipsis,
                                                order.name!,
                                                style: heading2,
                                              ),
                                              AutoSizeText(
                                                'Rs.${order.totalPrice.toString()}',
                                                overflow: TextOverflow.ellipsis,
                                                style: heading2,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Size: ${order.price!.first.name} (${order.price!.first.price})",
                                            style: des2,
                                          ),
                                          Text(
                                            "Extras:",
                                            style: des2,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children:
                                                order.extras!.map((extra) {
                                              return Visibility(
                                                visible: extra.isAdded ?? false,
                                                child: Text(
                                                  "${extra.name} (${extra.price})",
                                                  style: des2,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
