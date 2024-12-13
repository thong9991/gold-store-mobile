import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool secondaryAppBar;
  final List<Widget>? action;
  final Widget? leading;

  const MyAppBar(
      {super.key,
      required this.title,
      this.secondaryAppBar = false,
      this.action,
      this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: secondaryAppBar
            ? Theme.of(context).textTheme.titleMedium
            : Theme.of(context).textTheme.titleLarge,
      ),
      actions: action,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0.h);
}
