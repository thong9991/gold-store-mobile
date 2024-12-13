import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitCancelButton extends StatelessWidget {
  const SubmitCancelButton(
      {super.key,
      required this.submitText,
      required this.cancelText,
      required this.onCancel,
      required this.onSubmit,
      this.submitIcon = Icons.check_rounded,
      this.cancelIcon = Icons.close_rounded});

  final String submitText;
  final String cancelText;
  final Function() onCancel;
  final Function() onSubmit;
  final IconData submitIcon;
  final IconData cancelIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey.shade200,
            ),
            onPressed: onCancel,
            icon: Icon(cancelIcon),
            label: Text(cancelText),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        Expanded(
          flex: 5,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightBlueAccent,
            ),
            onPressed: onSubmit,
            icon: Icon(submitIcon),
            label: Text(submitText),
          ),
        ),
        // Expanded(flex: 5, child: ,)
      ],
    );
  }
}
