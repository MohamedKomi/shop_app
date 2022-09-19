import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_a/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;

  const CartItem(
      {super.key,
      required this.id,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("Do you want to remove the item from the cart?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("No")),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Yes"))
              ],
            ),
          );
        },
        onDismissed: (direction) => Provider.of<Cart>(context).removeItem(productId),
        key: ValueKey(id),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$$price'),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text('Total \$${price * quantity}'),
              trailing: Text('$quantity x'),
            ),
          ),
        ));
  }
}
