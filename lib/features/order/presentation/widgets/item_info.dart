import 'package:flutter/material.dart';

class ItemInfo extends StatelessWidget {
  const ItemInfo({super.key, required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(label)),
        value == null
            ? Container()
            : Expanded(
                flex: 2, child: Text("$value", textAlign: TextAlign.right))
      ],
    );
  }
}
