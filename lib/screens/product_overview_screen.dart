import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_a/providers/products.dart';
import 'package:test_a/screens/cart_screen.dart';
import 'package:test_a/screens/profile.dart';
import 'package:test_a/widgets/app_drawer.dart';
import 'package:test_a/widgets/badge.dart';
import 'package:test_a/widgets/favorite_products_grid.dart';
import 'package:test_a/widgets/products_grid.dart';

import '../providers/cart.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routName = '/overView';

  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  late List _pages;
  int _selectedPageIndex = 0;

  late var timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _isLoading = true;
      Provider.of<Products>(context, listen: false).fetchAndSetProducts();
      timer = Timer.periodic(
        const Duration(seconds: 2),
        (Timer t) => setState(() {
          _isLoading = false;
        }),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      const ProductGrid(),
      const FavoriteProductGrid(),
      const ProfileScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
                value: cart.itemsCount.toString(),
                color: Theme.of(context).accentColor,
                child: ch!),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routName),
            ),
          )
        ],
        title: const Text("Shop"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedPageIndex] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.star),
            label: 'Favorite Products',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}
