
import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          height: _width / 2.7,
          width: _width / 2.7,
          child: Animator<double>(
            duration: const Duration(milliseconds: 1000),
            cycles: 0,
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 15.0, end: 25.0),
            builder: (context, animatorState, child) => Icon(
              Icons.shopping_cart,
              size: animatorState.value * 5,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}