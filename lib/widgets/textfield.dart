import 'package:flutter/material.dart';

import 'colors.dart';

Widget textEdit(
    controller,
    String label,
    int line,
    keyboardType,
    bool iSprefix,
    bool isIcon,
    String prefix,
    Color iconColor,
    BuildContext context,
    bool obscure,
    IconData icon) {
  return TextField(
    maxLines: line,
    minLines: line,
    controller: controller,
    cursorColor: Theme.of(context).hintColor,
    style: TextStyle(
        color: Theme.of(context).hintColor, fontSize: 14, fontFamily: 'Nunito'),
    decoration: InputDecoration(
      icon: isIcon == true
          ? Icon(
              icon,
              color: iconColor,
              size: 30,
            )
          : null,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).cardColor,
        ),
      ),
      prefix: const SizedBox(width: 10),
      suffixIcon: iSprefix == true && isIcon == false
          ? CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).focusColor,
              child: Icon(
                icon,
                size: 20,
                color: AppColors.activColor,
              ),
            )
          : null,
      hintText: label,
      labelText: iSprefix == true ? prefix : null,
      hintStyle: TextStyle(
          color: Theme.of(context).cardColor,
          fontSize: 14,
          fontFamily: 'Nunito'),
      labelStyle: TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 14,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w900,
      ),
    ),
    keyboardType: keyboardType,
    obscureText: obscure == true ? true : false,
  );
}
