import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/enum/data_source.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/nummeric_text_formater.dart';
import 'label_content.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.hint,
      this.suffixText,
      this.controller,
      this.onChanged,
      this.numeric = false,
      this.type = InputType.TEXT,
      this.inLine = false,
      this.readOnly = false,
      this.padding});

  final String? hint;
  final String? suffixText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool numeric;
  final InputType type;
  final bool inLine;
  final bool readOnly;
  final REdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? REdgeInsets.only(bottom: 7, top: 0),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: inLine ? TextAlign.end : TextAlign.start,
        cursorWidth: 0.2,
        keyboardType:
            type != InputType.TEXT ? TextInputType.number : TextInputType.text,
        inputFormatters: type == InputType.CURRENCY
            ? [NumericTextFormatter()]
            : type == InputType.GOLD_AMOUNT
                ? [GoldAmountTextFormatter()]
                : [],
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          hintText: hint ?? "",
          suffixText: suffixText ?? "",
        ),
      ),
    );
  }
}

class LabelTextField extends StatelessWidget {
  const LabelTextField(
      {super.key,
      required this.label,
      this.controller,
      this.onChanged,
      this.numeric = false,
      this.type = InputType.TEXT,
      this.suffixText,
      required this.hint});

  final String label;
  final String hint;
  final String? suffixText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool numeric;
  final InputType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 5, child: Label(label: label)),
          Expanded(
              flex: 5,
              child: CustomTextField(
                onChanged: onChanged,
                hint: hint,
                padding: REdgeInsets.symmetric(vertical: 0),
                inLine: true,
                type: type,
                numeric: numeric,
                suffixText: suffixText ?? "",
              ))
        ],
      ),
    );
  }
}

class OrderExchangeHeader extends StatelessWidget {
  const OrderExchangeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 7,
            child: Text(
              AppStrings.strGoldType.tr(context),
              textAlign: TextAlign.left,
            )),
        Expanded(
            flex: 3,
            child: Text(AppStrings.strGoldWeight.tr(context),
                textAlign: TextAlign.right))
      ],
    );
  }
}

class AccordionTextField extends StatelessWidget {
  const AccordionTextField(
      {required this.label,
      this.initialValue,
      this.numeric = false,
      this.isCurrency = false,
      this.isGoldAmount = false,
      this.suffixText,
      this.onChanged,
      required this.hint});

  final String label;
  final String hint;
  final String? initialValue;
  final Function(String)? onChanged;
  final String? suffixText;
  final bool numeric;
  final bool isCurrency;
  final bool isGoldAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 5, child: Text(label)),
        Expanded(
          flex: 5,
          child: TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            cursorWidth: 0.2,
            initialValue: initialValue,
            onChanged: onChanged,
            textAlign: TextAlign.right,
            keyboardType: numeric ? TextInputType.number : TextInputType.text,
            inputFormatters: isCurrency
                ? [
                    NumericTextFormatter(),
                    LengthLimitingTextInputFormatter(7),
                  ]
                : isGoldAmount
                    ? [
                        GoldAmountTextFormatter(),
                        LengthLimitingTextInputFormatter(5)
                      ]
                    : [],
            decoration: InputDecoration(
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                suffixText: suffixText,
                isCollapsed: true),
          ),
        )
      ],
    );
  }
}
