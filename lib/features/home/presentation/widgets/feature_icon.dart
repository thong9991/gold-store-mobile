import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FeatureIcon extends StatelessWidget {
  const FeatureIcon(
      {super.key, required this.label, required this.icon, required this.page});

  final String label;
  final String page;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.w,
                  offset: const Offset(4, 8), // Shadow position
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.blueAccent,
              size: 20.r,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
      onTap: () {
        context.push(
          '/HomePage/$page',
        );
      },
    );
  }
}
