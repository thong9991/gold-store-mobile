import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/app_bar/appbar_widget.dart';
import '../../../../core/common/widgets/button/submit_cancel_button.dart';
import '../../../../core/enum/data_source.dart';
import '../widgets/widgets.dart';

class ExchangeGoldPage extends StatelessWidget {
  const ExchangeGoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExchangeGoldView();
  }
}

class ExchangeGoldView extends StatefulWidget {
  const ExchangeGoldView({super.key});

  @override
  State<ExchangeGoldView> createState() => _ExchangeGoldViewState();
}

class _ExchangeGoldViewState extends State<ExchangeGoldView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Mua/bán vàng",
        secondaryAppBar: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
            size: 30.r,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        margin: REdgeInsets.all(10),
        padding: REdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Label(label: "Chi tiết đơn hàng:"),
              Material(
                color: Colors.white,
                child: Ink(
                  width: 100.w,
                  height: 30.h,
                  padding: REdgeInsets.only(left: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      border: Border.all(),
                      color: Colors.white),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 20.r,
                        ),
                        Text(
                          "Thêm",
                          style: Theme.of(context).textTheme.labelMedium,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Label(label: "Ghi chú :"),
              const CustomTextField(
                hint: "Ghi chú sản phẩm",
              ),
              const LabelContent(
                  label: 'Tổng tiền vàng:', content: "7,000,000"),
              const LabelTextField(
                label: "Giảm giá:",
                hint: "",
                suffixText: ',000 đ',
                type: InputType.CURRENCY,
                numeric: true,
              ),
              const LabelContent(label: 'Thành tiền:', content: "8,000,000"),
              SubmitCancelButton(
                submitText: "Tạo đơn",
                cancelText: "Hủy",
                onCancel: () {},
                onSubmit: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
