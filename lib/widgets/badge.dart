import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget? child;
  final String value;
  final Color color;

  const Badge({required this.value, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
      child: Stack(
        children: [
          child!,
          Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color),
                constraints: BoxConstraints(minHeight: 16, minWidth: 16),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }
}
