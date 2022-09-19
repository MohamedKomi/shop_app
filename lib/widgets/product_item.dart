import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_a/screens/product_detail_screen.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavouriteStatus(
                      authData.token!, authData.userId!);
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border)),
          ),
          trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                // Scaffold.of(context).hideCurrentSnackBar();
                // Scaffold.of(context).showSnackBar(SnackBar(
                //   content: const Text("Added an item!"),
                //   duration: const Duration(seconds: 2),
                //   action: SnackBarAction(
                //     label: "Done!",
                //     onPressed: () => cart.removeSingleItem(product.id),
                //   ),
                // ));
              }),
          title: Text(product.title),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routName, arguments: product.id),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
              const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
