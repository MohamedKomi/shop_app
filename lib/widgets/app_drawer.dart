import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_a/screens/create_profile.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("My Shop"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Orders"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Manage Products"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routName),
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About the application"),
              onTap: () {}),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.group),
              title: const Text("About the team "),
              onTap: () => {}),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.group),
              title: const Text("creat profile"),
              onTap: () =>
                  {Navigator.of(context).pushNamed(CreateProfile.routName)}),
          const Divider(
            color: Colors.red,
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("LogOut"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
