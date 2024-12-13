import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import 'language_manager.dart';

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: Constants.empty);
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,###");
      final number = int.parse(
          newValue.text.replaceAll(f.symbols.GROUP_SEP, Constants.empty));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}

class GoldAmountTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: Constants.empty);
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final f = NumberFormat("0.000");
      final number = int.parse(newValue.text
              .replaceAll(f.symbols.DECIMAL_SEP, Constants.empty)) /
          1000;
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
      );
    } else {
      return newValue;
    }
  }
}

String convertToCurrency(
  BuildContext context,
  int number,
) {
  return "${NumberFormat('#,###').format(number)}"
      ",000 ${AppStrings.strVND.tr(context)}";
}
