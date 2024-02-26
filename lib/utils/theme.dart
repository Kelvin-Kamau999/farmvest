import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cofarmer/utils/constants.dart';

ThemeData theme() {
  return ThemeData(
    appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        titleTextStyle: GoogleFonts.manrope(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        iconTheme: const IconThemeData(color: Colors.black)),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: kPrimaryColor, selectionColor: kPrimaryColor),
    textTheme: Typography.englishLike2021.apply(
        fontSizeFactor: 1,
        bodyColor: Colors.black,
        fontFamily: GoogleFonts.manrope().fontFamily),
    primaryColor: kPrimaryColor,
  );
}
