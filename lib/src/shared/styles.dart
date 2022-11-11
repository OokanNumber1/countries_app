import 'package:flutter/material.dart';
import 'package:countries_app/src/shared/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ThemeData get lightTheme => ThemeData(
      checkboxTheme: const CheckboxThemeData(
        fillColor: MaterialStatePropertyAll(AppColors.grayWarm),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      fontFamily: "Axiforma",
      brightness: Brightness.light,
      textTheme: const TextTheme(
        labelMedium: TextStyle(
          fontSize: 14,
          color: AppColors.grayWarm,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: AppColors.gray500,
        ),
        displaySmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.grayWarm,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.gray500,
        ),
        displayMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.grayWarm,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

ThemeData get darkTheme => ThemeData(
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.black),
      checkboxTheme: const CheckboxThemeData(
        checkColor: MaterialStatePropertyAll(Colors.black),
        fillColor: MaterialStatePropertyAll(AppColors.gray200),
      ),
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: const TextTheme(
        labelMedium: TextStyle(
          fontSize: 14,
          color: AppColors.gray100,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: AppColors.gray400,
        ),
        displaySmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.gray100,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: AppColors.gray100,
        ),
        displayMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.gray100,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
