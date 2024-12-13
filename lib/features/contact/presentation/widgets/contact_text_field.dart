import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactField extends StatelessWidget {
  const ContactField(
      {super.key,
      required this.icon,
      required this.row1,
      required this.row2,
      this.action});

  final IconData icon;
  final Widget row1;
  final Widget row2;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: REdgeInsets.all(15),
              child: Icon(
                icon,
                size: 25.sp,
              ),
            )),
        Expanded(
            flex: 7,
            child: Padding(
              padding: REdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [row1, row2],
              ),
            )),
        Expanded(
          flex: 1,
          child: Padding(
            padding: REdgeInsets.only(top: 15),
            child: action ?? Container(),
          ),
        ),
      ],
    );
  }
}
