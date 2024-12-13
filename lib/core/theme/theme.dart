import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData themeData = ThemeData(
  primaryColor: Colors.grey,
  scaffoldBackgroundColor: Colors.grey.shade100,
  fontFamily: 'San Francisco',
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.sp),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
        color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 25.sp),
    displayMedium: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp),
    displaySmall: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.sp),
    titleLarge: TextStyle(
        color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 25.sp),
    titleMedium: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
    titleSmall: TextStyle(
        color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12.sp),
    labelLarge: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
    labelMedium: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.sp),
    labelSmall: TextStyle(
        color: Colors.green, fontWeight: FontWeight.w400, fontSize: 8.sp),
    bodyMedium:
        TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13.sp),
    bodySmall: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 10.sp),
  ),
  navigationBarTheme: const NavigationBarThemeData(
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStatePropertyAll(TextStyle())),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
    },
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color(0xffd6d6d6),
    cursorColor: Colors.black,
    selectionHandleColor: Colors.black,
  ),
);
