import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../data/models/contact.dart';
import '../../domain/entities/contact.dart';
import '../bloc/contact_bloc.dart';
import '../widgets/contact_item.dart';

const CONTACT_PER_PAGE = 25;

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ContactBloc>()
        ..add(SearchInit())
        ..add(const ContactLoad(page: 1)),
      child: const ContactListView(),
    );
  }
}

class ContactListView extends StatelessWidget {
  const ContactListView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
            padding: REdgeInsets.all(10),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Text(
                      AppStrings.strContactPage.tr(context),
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          context.read<ContactBloc>().add(
                              const ContactChange(contact: ContactModel.empty));
                          context.push("/ContactListPage/AddContactPage");
                        },
                        icon: Icon(
                          Icons.add_rounded,
                          size: 20.r,
                        ))
                  ],
                  backgroundColor: Colors.white,
                ),
                MultiBlocListener(
                  listeners: [
                    BlocListener<ContactBloc, ContactState>(
                      listenWhen: (previous, current) {
                        return previous.addContactStatus !=
                            current.addContactStatus;
                      },
                      listener: (context, state) {
                        if (state.addContactStatus !=
                            AddContactStatus.initial) {
                          if (state.addContactStatus ==
                              AddContactStatus.success) {
                            showSnackBar(context, ToastificationType.success,
                                AppStrings.strAddContactSuccessful, true);
                          }
                          context.read<ContactBloc>().add(
                              const UpdateContactStatusChange(
                                  status: UpdateContactStatus.initial));
                        }
                      },
                    ),
                    BlocListener<ContactBloc, ContactState>(
                      listenWhen: (previous, current) {
                        return previous.updateContactStatus !=
                            current.updateContactStatus;
                      },
                      listener: (context, state) {
                        if (state.updateContactStatus !=
                            UpdateContactStatus.initial) {
                          if (state.updateContactStatus ==
                              UpdateContactStatus.success) {
                            showSnackBar(context, ToastificationType.success,
                                AppStrings.strEditContactSuccessful, true);
                          }
                          if (state.updateContactStatus ==
                              UpdateContactStatus.failure) {
                            showSnackBar(
                                context,
                                ToastificationType.error,
                                state.message,
                                state.message.split(" ").length < 4);
                          }
                          context.read<ContactBloc>().add(
                              const UpdateContactStatusChange(
                                  status: UpdateContactStatus.initial));
                        }
                      },
                    ),
                    BlocListener<ContactBloc, ContactState>(
                      listenWhen: (previous, current) {
                        return previous.deleteContactStatus !=
                            current.deleteContactStatus;
                      },
                      listener: (context, state) {
                        if (state.deleteContactStatus !=
                            DeleteContactStatus.initial) {
                          if (state.deleteContactStatus ==
                              DeleteContactStatus.failure) {
                            showSnackBar(
                                context,
                                ToastificationType.error,
                                state.message,
                                state.message.split(' ').length < 4);
                          }
                          if (state.deleteContactStatus ==
                              DeleteContactStatus.success) {
                            showSnackBar(context, ToastificationType.success,
                                AppStrings.strDeleteContactSuccessful, true);
                          }
                          context.read<ContactBloc>().add(
                              const UpdateContactStatusChange(
                                  status: UpdateContactStatus.initial));
                        }
                      },
                    ),
                  ],
                  child: BlocBuilder<ContactBloc, ContactState>(
                    buildWhen: (previous, current) {
                      return current.suggestionStatus !=
                          previous.suggestionStatus;
                    },
                    builder: (context, state) {
                      return SliverAppBar(
                        title: TypeAheadField<String>(
                            controller: searchController,
                            builder: (context, controller, focusNode) =>
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.r)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2.r,
                                        offset: const Offset(
                                            4, 8), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: controller,
                                    onChanged: (value) {
                                      if (value.trim().isEmpty) {
                                        context
                                            .read<ContactBloc>()
                                            .add(const ContactLoad(page: 1));
                                      } else {
                                        context.read<ContactBloc>().add(
                                            SearchChange(
                                                keywords: controller.text));
                                      }
                                    },
                                    focusNode: focusNode,
                                    onSubmitted: (value) {
                                      List<String> splitWords = searchController
                                          .text
                                          .trim()
                                          .split(' ');
                                      context.read<ContactBloc>().add(
                                          ContactSearch(
                                              keywords: splitWords
                                                ..removeWhere((value) => value
                                                    .toString()
                                                    .trim()
                                                    .isEmpty)));
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        size: 20.r,
                                      ),
                                      border: InputBorder.none,
                                      hintText: AppStrings.strSearchContactHint
                                          .tr(context),
                                    ),
                                  ),
                                ),
                            itemBuilder: (context, suggestion) => ListTile(
                                  title: Text(suggestion),
                                ),
                            emptyBuilder: (context) => ListTile(
                                title: state.suggestionStatus ==
                                        SuggestionStatus.initial
                                    ? const Text(Constants.empty)
                                    : const Text(
                                        'Không tìm thấy thông tin danh bạ')),
                            onSelected: (suggestion) {
                              List<String> splitWords =
                                  searchController.text.trim().split(' ');

                              splitWords.last = splitWords.length > 1
                                  ? suggestion.replaceAll('...', '')
                                  : suggestion;

                              List<String> keywords = splitWords
                                ..removeWhere(
                                    (value) => value.toString().trim().isEmpty);

                              searchController.text = splitWords.join(' ');

                              context
                                  .read<ContactBloc>()
                                  .add(ContactSearch(keywords: keywords));
                            },
                            suggestionsCallback: (key) {
                              return state.suggestions;
                            }),
                        pinned: true,
                        floating: true,
                        backgroundColor: Colors.white,
                        stretch: true,
                        expandedHeight: 50.h,
                        toolbarHeight: 50.h,
                        flexibleSpace: FlexibleSpaceBar(
                          background: SafeArea(
                              child: Container(
                            color: Colors.white,
                          )),
                          stretchModes: const [
                            StretchMode.zoomBackground,
                            StretchMode.blurBackground
                          ],
                        ),
                      );
                    },
                  ),
                ),
                BlocBuilder<ContactBloc, ContactState>(
                  builder: (context, state) {
                    List<ContactEntity> contacts = state.contacts;
                    return (state.contactStatus == ContactStatus.loading &&
                            state.contacts.isEmpty)
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                              height: .5.sh,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                            return ContactItem(
                              name: contacts[index].name,
                              phone: contacts[index].phone,
                              onTap: () {
                                context.read<ContactBloc>().add(
                                    ContactChange(contact: contacts[index]));
                                context
                                    .go("/ContactListPage/ContactDetailsPage");
                              },
                            );
                          }, childCount: contacts.length));
                  },
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<ContactBloc, ContactState>(
                    builder: (context, state) {
                      return (state.contactStatus == ContactStatus.loading &&
                              state.contacts.length > CONTACT_PER_PAGE)
                          ? SizedBox(
                              height: .5.sh,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
