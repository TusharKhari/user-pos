import 'package:flutter/material.dart';
import 'package:order_list_product_create/controler/product_listing_controller.dart';
import 'package:order_list_product_create/screens/products_listing_screen.dart';
import 'package:order_list_product_create/screens/cart_screen.dart';
import 'package:order_list_product_create/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductListingController(),
        )
      ],
      child: MaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
                child: child!,
                breakpoints: [
                  const Breakpoint(start: 0, end: 767, name: MOBILE),
                  const Breakpoint(start: 768, end: 1050, name: TABLET),
                  const Breakpoint(start: 768, end: 1400, name: 'MINI_DESKTOP'),
                  const Breakpoint(start: 1051, end: 1920, name: DESKTOP),
                ],
              ),
        title: 'Menu n Order',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ProductListingScreen(),
    CartScreen(),
  ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return  Consumer<ProductListingController>(
        builder: (context, providerValue, child) {
        return Scaffold(
          backgroundColor: backColor,
          body: Center(
            child: _widgetOptions.elementAt(providerValue.pageIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: primaryColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Consumer<ProductListingController>(
                    builder: (context, value, child) {
                  return Badge(
                      child: Icon(Icons.shopping_cart_sharp),
                      label: Text("${value.cartItems.length}"));
                }),
                label: 'Cart',
              ),
            ],
            currentIndex: providerValue.pageIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: backColor,
            onTap: (value) {
              providerValue.changePageIndex(idx: value);
            },
          ),
        );
      }
    );
  }
}
