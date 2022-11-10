import 'package:flutter/material.dart';

ThemeData lightTheme(){
return ThemeData.light().copyWith(
  textTheme: TextTheme(
    titleMedium: TextStyle()
  )
);
}