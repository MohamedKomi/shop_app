import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_a/providers/products.dart';
import 'package:test_a/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String? id;
  final String title;
  final String imageUrl;

  const UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductScreen.routName, arguments: id!),
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id!);
                  } catch (e) {
                    // scaffold.showSnackBar(
                    //   const SnackBar(
                    //     content: Text(
                    //       "Deleting Failed!",
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // );
                  }
                },
                color: Theme.of(context).errorColor,
                icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
