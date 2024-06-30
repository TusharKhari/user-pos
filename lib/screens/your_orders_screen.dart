import 'package:flutter/material.dart';
import 'package:order_list_product_create/controler/product_listing_controller.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(title: Text("Your orders"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProductListingController>(
              builder: (context, providerVal, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // itemCount: 888,
                  itemCount: providerVal.yourOrderList.length,
                  itemBuilder: (context, index) {
                    var order = providerVal.yourOrderList[index];
                    return Text("${order.name}");
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
