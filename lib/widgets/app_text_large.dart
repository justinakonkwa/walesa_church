import 'package:flutter/material.dart';

// class du widget qui possede le text en gras et la grande police
// ignore: must_be_immutable
class AppTextLarge extends StatelessWidget {
  AppTextLarge({
    Key? key,
    this.size = 30,
    required this.text,
    required this.color,
  }) : super(key: key);
  double size;
  final String? text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
      ),
    );
  }
}
