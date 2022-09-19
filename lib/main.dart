import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_a/providers/products.dart';
import 'package:test_a/providers/profile.dart';
import 'package:test_a/screens/create_profile.dart';
import 'package:test_a/screens/profile.dart';
import './screens/product_overview_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';
import './screens/user_products_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Profile()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (ctx, authValue, previousProducts) => previousProducts!
              ..getData(authValue.userId.toString(), authValue.token.toString(),
                  previousProducts.items)),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(),
            update: (ctx, authValue, previousOrders) => previousOrders!
              ..getData(authValue.userId.toString(), authValue.token.toString(),
                  previousOrders.orders)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogIn(),
                    builder: (ctx, AsyncSnapshot snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : const AuthScreen()),
            routes: {
              ProductDetailScreen.routName: (_) => const ProductDetailScreen(),
              CartScreen.routName: (_) => const CartScreen(),
              UserProductScreen.routName: (_) => const UserProductScreen(),
              OrdersScreen.routName: (_) => const OrdersScreen(),
              EditProductScreen.routName: (_) => const EditProductScreen(),
              CreateProfile.routName: (_) => CreateProfile(),
              ProfileScreen.routName: (_) => const ProfileScreen(),
              ProductOverviewScreen.routName: (_) =>
                  const ProductOverviewScreen(),
            },
          );
        },
      ),
    );
  }
}
