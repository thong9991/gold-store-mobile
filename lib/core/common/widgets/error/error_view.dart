import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.errorMsg, required this.errorType});

  final String errorMsg;
  final String errorType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Error $errorType",
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
            ),
            Text(
              errorMsg,
              style: TextStyle(fontSize: 13.sp, color: Colors.redAccent),
            )
          ],
        ),
      ),
    );
  }
}
