import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_palette.dart';

class ContactItem extends StatelessWidget {
  final String name;
  final String phone;
  final Function() onTap;

  const ContactItem(
      {super.key,
      required this.name,
      required this.phone,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding: REdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        dense: true,
        leading: CircleAvatar(
            radius: 20.r,
            backgroundColor: AppPalette.contactColor,
            child: Text(name[0].toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white))),
        title: Text(name, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(
          phone,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 20.r,
        ),
        onTap: onTap,
        tileColor: Colors.white,
      ),
    );
  }
}
