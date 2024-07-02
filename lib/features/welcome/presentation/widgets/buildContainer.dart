import 'package:flutter/material.dart';

Widget buildContainer(bool isActive, bool isSecond) {
  return Expanded(
    child: AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin:
          (isSecond) ? EdgeInsets.symmetric(horizontal: 3.0) : EdgeInsets.zero,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    ),
  );
}
