import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/language_manager.dart';
import '../bloc/contact_bloc.dart';
import '../widgets/contact_avatar.dart';

class ContactDetailsPage extends StatelessWidget {
  const ContactDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ContactBloc>(),
      child: const ContactDetailsView(),
    );
  }
}

class ContactDetailsView extends StatefulWidget {
  const ContactDetailsView({super.key});

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView> {
  @override
  Widget build(BuildContext context) {
    String editText = AppStrings.strEdit.tr(context);
    String deleteText = AppStrings.strDelete.tr(context);

    List<String> actions = <String>[editText, deleteText];
    showDeleteConfirmation() {
      Widget cancelButton = TextButton(
        child: Text(
          AppStrings.strCancel.tr(context),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        onPressed: () {
          context.pop();
        },
      );
      Widget deleteButton = TextButton(
        child: Text(deleteText),
        onPressed: () async {
          context.read<ContactBloc>().add(ContactRemove());
          context.pop();
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text(AppStrings.strDeleteContact.tr(context)),
        content: Text(AppStrings.strEnsureDeleteContact.tr(context)),
        actions: <Widget>[cancelButton, deleteButton],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }

    onAction(String action) async {
      if (action == editText) {
        context.push("/ContactListPage/ContactDetailsPage/EditContactPage");
      }
      if (action == deleteText) {
        showDeleteConfirmation();
      }
    }

    return BlocListener<ContactBloc, ContactState>(
      listenWhen: (previous, current) {
        return previous.deleteContactStatus != current.deleteContactStatus;
      },
      listener: (context, state) {
        if (state.deleteContactStatus != DeleteContactStatus.initial) {
          context
            ..pop()
            ..go("/ContactListPage");
          context.read<ContactBloc>().add(const UpdateContactStatusChange(
              status: UpdateContactStatus.initial));
        }
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(child: BlocBuilder<ContactBloc, ContactState>(
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
                          size: 100.h,
                          name: state.contact.name.isNotEmpty
                              ? state.contact.name
                              : "A",
                        )),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: REdgeInsets.all(8),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 20.r,
                              ),
                              onPressed: () {
                                context.pop();
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: PopupMenuButton(
                              onSelected: onAction,
                              itemBuilder: (BuildContext context) {
                                return actions.map((String action) {
                                  return PopupMenuItem(
                                    value: action,
                                    child: Text(action),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ContactInfoRow(
                      label: AppStrings.strContactName.tr(context),
                      value: state.contact.name),
                  ContactInfoRow(
                      label: AppStrings.strPhone.tr(context),
                      value: state.contact.phone),
                  Container(
                    width: double.infinity,
                    margin: REdgeInsets.all(5),
                    padding: REdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.r))),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "${AppStrings.strDescription.tr(context)}\n",
                          style: Theme.of(context).textTheme.labelMedium),
                      TextSpan(
                          text: state.contact.description,
                          style: Theme.of(context).textTheme.bodyMedium)
                    ])),
                  ),
                ]);
          },
        )),
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  const ContactInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.all(5),
      padding: REdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 5,
              child: Text(
                "$label:",
                style: Theme.of(context).textTheme.labelMedium,
              )),
          Flexible(
              flex: 5,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              )),
        ],
      ),
    );
  }
}
