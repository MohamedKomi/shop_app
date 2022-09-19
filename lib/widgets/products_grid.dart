import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_a/providers/products.dart';
import 'package:test_a/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {

  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final product = productData.items;
    return product.isEmpty? const Center(child: Text("There is no product!"),):GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10),
        itemCount: product.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: product[i],
          child: const ProductItem(),
        ));
  }
}
