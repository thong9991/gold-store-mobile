part of 'contact_bloc.dart';

enum ContactStatus { initial, loading, success, failure }

enum AddContactStatus { initial, loading, success, failure }

enum UpdateContactStatus { initial, loading, success, failure }

enum DeleteContactStatus { initial, success, failure }

enum SuggestionStatus { initial, loading, loaded }

enum ContactSearchStatus { initial, loaded }

final class ContactState extends Equatable {
  const ContactState(
      {this.contactStatus = ContactStatus.initial,
      this.suggestionStatus = SuggestionStatus.initial,
      this.contactSearchStatus = ContactSearchStatus.initial,
      this.addContactStatus = AddContactStatus.initial,
      this.updateContactStatus = UpdateContactStatus.initial,
      this.deleteContactStatus = DeleteContactStatus.initial,
      this.currentPage = Constants.zero,
      this.keywords = Constants.empty,
      this.dictionaryMap = const {},
      this.suggestions = const [],
      this.contacts = const [],
      this.contact = ContactModel.empty,
      this.updateData = ContactModel.empty,
      this.message = ''});

  final SuggestionStatus suggestionStatus;
  final ContactSearchStatus contactSearchStatus;
  final ContactStatus contactStatus;
  final AddContactStatus addContactStatus;
  final UpdateContactStatus updateContactStatus;
  final DeleteContactStatus deleteContactStatus;
  final int currentPage;
  final String keywords;
  final List<ContactEntity> contacts;
  final ContactEntity contact;
  final ContactEntity updateData;
  final Map<String, List<int>> dictionaryMap;
  final List<String> suggestions;
  final String message;

  ContactState copyWith(
      {ContactStatus? contactStatus,
      ContactSearchStatus? contactSearchStatus,
      SuggestionStatus? suggestionStatus,
      AddContactStatus? addContactStatus,
      UpdateContactStatus? updateContactStatus,
      DeleteContactStatus? deleteContactStatus,
      int? currentPage,
      String? keywords,
      Map<String, List<int>>? dictionaryMap,
      List<ContactEntity>? contacts,
      ContactEntity? contact,
      ContactEntity? updateData,
      List<String>? suggestions,
      String? message}) {
    return ContactState(
        contactStatus: contactStatus ?? this.contactStatus,
        suggestionStatus: suggestionStatus ?? this.suggestionStatus,
        contactSearchStatus: contactSearchStatus ?? this.contactSearchStatus,
        addContactStatus: addContactStatus ?? this.addContactStatus,
        updateContactStatus: updateContactStatus ?? this.updateContactStatus,
        deleteContactStatus: deleteContactStatus ?? this.deleteContactStatus,
        currentPage: currentPage ?? this.currentPage,
        keywords: keywords ?? this.keywords,
        dictionaryMap: dictionaryMap ?? this.dictionaryMap,
        contacts: contacts ?? this.contacts,
        contact: contact ?? this.contact,
        updateData: updateData ?? this.updateData,
        suggestions: suggestions ?? this.suggestions,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => [
        suggestionStatus,
        contactStatus,
        contactSearchStatus,
        addContactStatus,
        updateContactStatus,
        deleteContactStatus,
        currentPage,
        keywords,
        dictionaryMap,
        suggestions,
        contacts,
        contact,
        updateData,
        message
      ];
}
