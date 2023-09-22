// ignore_for_file: deprecated_member_use, unused_local_variable, sized_box_for_whitespace

import 'dart:async';
import 'package:flutter/material.dart';
import 'page/home_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<DarkThemeProvider>(context);
    // bool isTheme = themeChange.darkTheme;
    return Container(
      height: double.maxFinite,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/walesa.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
