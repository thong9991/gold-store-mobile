import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/language_manager.dart';

class Label extends StatelessWidget {
  const Label({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 5),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class Content extends StatelessWidget {
  const Content({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 7),
      child: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.end,
      ),
    );
  }
}

class LabelContent extends StatelessWidget {
  const LabelContent({
    super.key,
    required this.label,
    required this.content,
  });

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 5, child: Label(label: label)),
          Expanded(flex: 5, child: Content(content: content))
        ],
      ),
    );
  }
}

class OrderExchangeLine extends StatelessWidget {
  OrderExchangeLine({super.key, required this.goldType, required this.amount});

  final String goldType;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 7,
            child: Text(
              goldType.tr(context),
              textAlign: TextAlign.left,
            )),
        Expanded(
            flex: 3,
            child: Text("${amount.abs()} ${AppStrings.strMace.tr(context)}",
                textAlign: TextAlign.right))
      ],
    );
  }
}
