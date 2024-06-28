import 'package:flutter/material.dart';
import 'package:order_list_product_create/controler/product_listing_controller.dart';
import 'package:order_list_product_create/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  final int itemIndex;

  const ItemDetailScreen({Key? key, required this.itemIndex}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int? selectedPriceIndex;
  List<int> selectedExtrasIndexes = [];

  @override
  Widget build(BuildContext context) {
    var item =
        context.read<ProductListingController>().productsList[widget.itemIndex];

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        title: Text(
          item.name ?? "Item Details",
          style: heading2,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ProductListingController>(
              builder: (context, providerValue, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name ?? "", style: heading3),
                SizedBox(height: 10),
                Text(item.description ?? "", style: des2),
                SizedBox(height: 20),
                Text("SIZES", style: heading2),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: borderColor,
                      border: Border.all(color: boxColor)),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: item.price?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: boxColor))),
                        child: RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          fillColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return primaryColor;
                              }
                              return boxColor;
                            },
                          ),
                          title: Text(
                            "${item.price?[index].name} - ${item.price?[index].price}",
                            style: des2,
                          ),
                          value: index,
                          groupValue: selectedPriceIndex,
                          onChanged: (int? value) {
                            setState(() {
                              selectedPriceIndex = value;
                            });
                            providerValue.selectPrice(
                                index: index, priceIdex: index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Extras",
                  style: heading2,
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: borderColor,
                      border: Border.all(color: boxColor)),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: item.extras?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: boxColor))),
                        child: CheckboxListTile(
                          fillColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return primaryColor;
                              }
                              return boxColor;
                            },
                          ),
                          title: Text(
                            "${item.extras?[index].name} - ${item.extras?[index].price}",
                            style: des2,
                          ),
                          value: selectedExtrasIndexes.contains(index),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedExtrasIndexes.add(index);
                              } else {
                                selectedExtrasIndexes.remove(index);
                              }
                              providerValue.selectExtra(
                                  index: index, extraIdx: index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: Container(
        color: primaryColor,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context
                        .read<ProductListingController>()
                        .decreaseQuantity(index: widget.itemIndex);
                  },
                  icon: Icon(Icons.remove, color: Colors.white),
                ),
                Consumer<ProductListingController>(
                  builder: (context, providerValue, child) {
                    var quantity =
                        providerValue.productsList[widget.itemIndex].quantity;
                    return Text(" ${quantity == 0 ? 'QTY' : '$quantity'} ",
                        style: button);
                  },
                ),
                IconButton(
                  onPressed: () {
                    context
                        .read<ProductListingController>()
                        .increaseQuantity(index: widget.itemIndex);
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  if (item.quantity == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('SELECT THE QUANTITY BEFORE ADDING TO CART'),
                    ));
                  } else {
                    context
                        .read<ProductListingController>()
                        .addItemInCart(index: widget.itemIndex);
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Add to Cart", style: button)),
          ],
        ),
      ),
    );
  }
}
