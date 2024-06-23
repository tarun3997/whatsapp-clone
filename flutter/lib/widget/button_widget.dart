import 'package:flutter/material.dart';

Widget defaultButton(String text) {
  return Container(
    width: 140,
    height: 45,
    decoration: BoxDecoration(
      color: const Color(0xff00a884),
      borderRadius: BorderRadius.circular(30)
    ),
    child: Center(
        child: Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600),
    )),
  );
}
