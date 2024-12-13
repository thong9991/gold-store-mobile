import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../../core/utils/get_color_gradient.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar(
      {super.key,
      required this.size,
      required this.name,
      this.imageUrl = "",
      this.color = Colors.grey,
      this.memoryImage});

  final double size;
  final String imageUrl;
  final Uint8List? memoryImage;
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: getColorGradient(Colors.red)),
        child: memoryImage != null
            ? CircleAvatar(backgroundImage: MemoryImage(memoryImage!))
            : (imageUrl.isNotEmpty)
                ? CircleAvatar(backgroundImage: NetworkImage(imageUrl))
                : CircleAvatar(
                    backgroundColor: color,
                    child: Text(name[0].toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: Colors.white))));
  }
}
