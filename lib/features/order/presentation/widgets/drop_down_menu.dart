import 'package:flutter/material.dart';

import '../../../../core/utils/language_manager.dart';

class CustomDropDownMenu extends StatefulWidget {
  const CustomDropDownMenu(
      {super.key, this.list = const [], this.hintText = "", this.controller});

  final List<String> list;
  final String? hintText;
  final TextEditingController? controller;

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  String? dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      hintText: widget.hintText,
      onSelected: (String? value) {
        setState(() {
          widget.controller?.text = value!;
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: List.generate(
          widget.list.length,
          (i) => DropdownMenuEntry<String>(
              value: widget.list[i],
              label: widget.list[i].tr(context),
              labelWidget: Text(
                widget.list[i].tr(context),
                style: Theme.of(context).textTheme.bodyMedium,
              ))),
    );
  }
}
