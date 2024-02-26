import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF26AA35);
const kSecondaryColor = Color(0xFF8AC640);

final kBorder = const Color(0xFF1A1A1A).withOpacity(0.1);
const kDark = Color(0xff264653);

OutlineInputBorder outlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(2),
  borderSide: BorderSide(
    color: const Color(0xFF1A1A1A).withOpacity(0.1),
    width: 1,
  ),
);
UnderlineInputBorder inputBorder = const UnderlineInputBorder(
  borderSide: BorderSide(
    color: kDark,
    width: 1,
  ),
);

OutlineInputBorder focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(2),
  borderSide: const BorderSide(
    color: kDark,
    width: 1,
  ),
);

OutlineInputBorder errorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(2),
  borderSide: const BorderSide(
    color: Colors.red,
    width: 1,
  ),
);
