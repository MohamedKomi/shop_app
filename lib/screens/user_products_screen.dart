import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_a/providers/products.dart';
import 'package:test_a/screens/edit_product_screen.dart';
import 'package:test_a/widgets/user_product_item.dart';

import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routName = '/user-product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(EditProductScreen.routName, arguments: ""),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, AsyncSnapshot snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  child: Consumer<Products>(
                    builder: (ctx, productData, _) => productData.items.isEmpty
                        ? const Center(
                            child: Text("You do not have products yet"),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                              itemBuilder: (_, int index) => Column(
                                children: [
                                  UserProductItem(
                                      id: productData.items[index].id,
                                      title: productData.items[index].title,
                                      imageUrl:
                                          productData.items[index].imageUrl)
                                ],
                              ),
                              itemCount: productData.items.length,
                            ),
                          ),
                  ),
                  onRefresh: () => _refreshProducts(context))),
      drawer: const AppDrawer(),
    );
  }
}
