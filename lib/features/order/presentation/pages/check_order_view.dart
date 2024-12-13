import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/app_bar/appbar_widget.dart';
import '../../../../core/common/widgets/button/submit_cancel_button.dart';
import '../widgets/widgets.dart';

class CheckOrderPage extends StatelessWidget {
  const CheckOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CheckOrderView();
  }
}

class CheckOrderView extends StatelessWidget {
  const CheckOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Kiêm kê",
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
        action: [
          IconButton(
              onPressed: () {
                context.push(
                  '/HomePage/CreateOrderPage/QRScanPage',
                );
              },
              icon: Icon(
                Icons.qr_code_2_rounded,
                size: 30.r,
              ))
        ],
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
              Accordion(
                  maxOpenSections: 1,
                  disableScrolling: true,
                  headerBackgroundColorOpened: Colors.black54,
                  scaleWhenAnimating: true,
                  openAndCloseAnimation: true,
                  paddingListTop: 8.r,
                  paddingListBottom: 8.r,
                  headerPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                  sectionClosingHapticFeedback: SectionHapticFeedback.light,
                  children: [
                    AccordionSection(
                      isOpen: false,
                      leftIcon: Icon(
                        Icons.discount_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
                      header: const Text(
                        'Nhãn sản phảm: 7B302990',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Column(
                        children: [
                          ItemInfo(
                            label: "Nhẫn kiễu(610)xxPNJViệtNam",
                          ),
                          ItemInfo(
                            label: "Tổng trọng lượng:",
                            value: "5.12p",
                          ),
                          ItemInfo(
                            label: "Trọng lượng đá:",
                            value: "3ly",
                          ),
                          ItemInfo(
                            label: "Trọng lượng vàng:",
                            value: "4.82p",
                          ),
                          ItemInfo(
                            label: "Vàng cắt:",
                            value: "4.82p",
                          ),
                          ItemInfo(
                            label: "Tiền công:",
                            value: "350,000đ",
                          ),
                        ],
                      ),
                    ),
                    AccordionSection(
                      isOpen: false,
                      leftIcon: Icon(
                        Icons.balance_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
                      header: const Text(
                        'Vàng khách đổi',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Column(
                        children: [
                          ItemInfo(
                            label: "Loại vàng",
                            value: "Trọng lượng",
                          ),
                          ItemInfo(
                            label: "Nhẫn tròn trơn 97%:",
                            value: "5p",
                          ),
                        ],
                      ),
                    ),
                  ]),
              const Label(label: "Ghi chú :"),
              const CustomTextField(
                hint: "Ghi chú sản phẩm",
                readOnly: true,
              ),
              const LabelContent(
                  label: 'Tổng tiền vàng:', content: "7,000,000"),
              const LabelContent(label: 'Tiền công:', content: "2,000,000"),
              const LabelContent(label: 'Giảm giá:', content: "50,000"),
              const LabelContent(label: 'Thành tiền:', content: "8,000,000"),
              SubmitCancelButton(
                submitText: "Hoàn tất",
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
