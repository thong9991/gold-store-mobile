import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/widgets/app_bar/appbar_widget.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/utils.dart';
import '../../data/models/contact.dart';
import '../../domain/entities/contact.dart';
import '../bloc/contact_bloc.dart';
import '../widgets/widgets.dart';

class EditContactPage extends StatelessWidget {
  const EditContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ContactBloc>(),
      child: const EditContactView(),
    );
  }
}

class EditContactView extends StatefulWidget {
  const EditContactView({super.key});

  @override
  State<EditContactView> createState() => _EditContactViewState();
}

class _EditContactViewState extends State<EditContactView> {
  String? _imgUrl;

  void selectImage() async {
    String? url = await pickImage(ImageSource.camera);
    setState(() {
      _imgUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    ContactEntity contact = context.read<ContactBloc>().state.contact;
    TextEditingController phoneController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    List<String> phoneTypes = [AppStrings.strMobile, AppStrings.strHome];
    phoneController.text = contact.phone;
    descriptionController.text = contact.description;
    return Scaffold(
      appBar: MyAppBar(
        title: AppStrings.strEditContactPage.tr(context),
        secondaryAppBar: true,
        action: [
          Padding(
            padding: REdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () {
                  context.read<ContactBloc>().add(ContactEdit());
                },
                child: Text(
                  AppStrings.strDone.tr(context),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                )),
          )
        ],
      ),
      body: BlocListener<ContactBloc, ContactState>(
        listenWhen: (previous, current) {
          return previous.updateContactStatus != current.updateContactStatus;
        },
        listener: (context, state) {
          if (state.updateContactStatus == UpdateContactStatus.success) {
            context
                .read<ContactBloc>()
                .add((const UpdateDataChange(contact: ContactModel.empty)));
          }
          context.go("/ContactListPage");
        },
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              child: BlocBuilder<ContactBloc, ContactState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: Stack(
                          children: [
                            Center(
                                child: ContactAvatar(
                              imageUrl: _imgUrl ?? Constants.empty,
                              size: 100.h,
                              name: state.updateData.name.trim().isNotEmpty
                                  ? state.updateData.name.trim()
                                  : state.contact.name.trim().isNotEmpty
                                      ? state.contact.name.trim()
                                      : "A",
                            )),
                            Positioned(
                              bottom: 30.h,
                              left: 0.5.sw + 20.h,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  size: 25.r,
                                ),
                                onPressed: selectImage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      ContactField(
                        row1: TextFormField(
                          initialValue: state.contact.name,
                          onChanged: (text) {
                            context.read<ContactBloc>().add((UpdateDataChange(
                                contact:
                                    ContactModel.fromEntity(state.updateData)
                                        .copyWith(
                                            name: text != state.contact.name ||
                                                    text.trim().isEmpty
                                                ? text
                                                : Constants.empty))));
                          },
                          decoration: InputDecoration(
                              hintText: AppStrings.strFullName.tr(context),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.normal)),
                        ),
                        row2: Container(),
                        icon: Icons.person_rounded,
                      ),
                      ContactField(
                        row1: TextFormField(
                          controller: phoneController,
                          onChanged: (text) {
                            context.read<ContactBloc>().add((UpdateDataChange(
                                contact: ContactModel.fromEntity(state.contact)
                                    .copyWith(
                                        phone: text != state.contact.phone ||
                                                text.trim().isEmpty
                                            ? text
                                            : Constants.empty))));
                          },
                          decoration: InputDecoration(
                              hintText: AppStrings.strPhone.tr(context),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.normal)),
                        ),
                        row2: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: DropdownMenu<String>(
                            width: 120.w,
                            initialSelection: state.contact.phoneType,
                            onSelected: (String? value) {
                              context.read<ContactBloc>().add(UpdateDataChange(
                                  contact:
                                      ContactModel.fromEntity(state.contact)
                                          .copyWith(phoneType: value)));
                            },
                            dropdownMenuEntries: List.generate(
                                phoneTypes.length,
                                (i) => DropdownMenuEntry<String>(
                                    value: phoneTypes[i],
                                    label: phoneTypes[i].tr(context),
                                    labelWidget: Text(
                                      phoneTypes[i].tr(context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ))),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        icon: Icons.phone,
                        action: state.contact.phone.isNotEmpty
                            ? SizedBox(
                                height: 25.sp,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 25.sp,
                                  ),
                                  onPressed: () {
                                    phoneController.text = Constants.empty;
                                    context.read<ContactBloc>().add(
                                        UpdateDataChange(
                                            contact: ContactModel.fromEntity(
                                                    state.contact)
                                                .copyWith(
                                                    phone: Constants.empty)));
                                  },
                                ),
                              )
                            : null,
                      ),
                      ContactField(
                        icon: Icons.note_alt_outlined,
                        row1: TextFormField(
                          controller: descriptionController,
                          onChanged: (text) {
                            context.read<ContactBloc>().add((ContactChange(
                                contact: ContactModel.fromEntity(state.contact)
                                    .copyWith(description: text))));
                          },
                          minLines: 1,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          // controller: descriptionFieldController,
                          decoration: InputDecoration(
                              hintText: AppStrings.strDescription.tr(context),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.normal)),
                        ),
                        row2: Container(),
                        action: state.contact.description.isNotEmpty
                            ? SizedBox(
                                height: 25.sp,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 25.sp,
                                  ),
                                  onPressed: () {
                                    descriptionController.text =
                                        Constants.empty;
                                    context.read<ContactBloc>().add(
                                        ContactChange(
                                            contact: ContactModel.fromEntity(
                                                    state.contact)
                                                .copyWith(
                                                    description:
                                                        Constants.empty)));
                                  },
                                ),
                              )
                            : null,
                      ),
                      SizedBox(
                        height: .75.sw,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
