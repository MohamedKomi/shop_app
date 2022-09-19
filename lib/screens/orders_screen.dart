import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your orders"),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text("An error occurred!"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => orderData.orders.isEmpty
                    ? const Center(
                        child: Text("You do not have orders yet"),
                      )
                    : ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (BuildContext context, int index) =>
                            OrderItem(orderData.orders[index]),
                      ),
              );
            }
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
