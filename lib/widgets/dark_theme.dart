// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'colors.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      
      shadowColor: isDarkTheme ? const Color(0xFF010013) : AppColors.activColor,
      dialogBackgroundColor:
          isDarkTheme ? AppColors.activColor : AppColors.mainColor,
      scaffoldBackgroundColor:
          isDarkTheme ? Colors.black : AppColors.mainColor,
      colorSchemeSeed: AppColors.activColor,
      backgroundColor:
          isDarkTheme ?  Colors.black: AppColors.mainColor,
      indicatorColor: const Color(0xFFABCDD7),
      unselectedWidgetColor:
          isDarkTheme ? AppColors.mainColor : AppColors.mainColor,
      hintColor: isDarkTheme ? AppColors.mainColor : AppColors.bigTextColor,
      cardColor: isDarkTheme ? const Color(0x79F1F0E9) : AppColors.textColor2,
      hoverColor:
          isDarkTheme ? const Color(0xFF808995) :  AppColors.simpleFondColor,
      focusColor:
          isDarkTheme ? Color(0xFF454444) : AppColors.simpleFondColor,
      dividerColor: isDarkTheme ? const Color(0xFF808995) : Colors.white,
      bottomAppBarColor:
          isDarkTheme ? AppColors.activColor : AppColors.mainTextColor,
      disabledColor:
          isDarkTheme ? AppColors.mainColor : AppColors.mainTextColor,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      secondaryHeaderColor:
          isDarkTheme ? const Color(0xFFA6A7A7) : const Color(0xFFBCC5D0),
      canvasColor:
          isDarkTheme ? const Color(0xFF808995) : AppColors.mainTextColor,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      fontFamily: isDarkTheme ? "images/plus.png" : "images/plus2.png",
    );
  }
}
// Color.fromARGB(255, 31, 38, 49)
// Theme.of(context).hintColor)