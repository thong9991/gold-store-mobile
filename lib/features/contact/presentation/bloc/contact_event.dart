part of 'contact_bloc.dart';

@immutable
sealed class ContactEvent {
  const ContactEvent();
}

// Contact list events.
final class SearchDataLoad extends ContactEvent {}

final class SearchInit extends ContactEvent {}

final class SearchChange extends ContactEvent {
  final String keywords;

  const SearchChange({required this.keywords});
}

final class ContactSearch extends ContactEvent {
  final List<String> keywords;

  const ContactSearch({required this.keywords});
}

final class ContactLoad extends ContactEvent {
  final int page;

  const ContactLoad({required this.page});
}

// Create/Edit contact events.
final class InitContact extends ContactEvent {
  final ContactEntity contact;

  const InitContact({required this.contact});
}

// Change contact fields events.
final class ContactChange extends ContactEvent {
  final ContactEntity contact;

  const ContactChange({required this.contact});
}

final class UpdateDataChange extends ContactEvent {
  final ContactEntity contact;

  const UpdateDataChange({required this.contact});
}

// Save created contact event.
final class ContactAdd extends ContactEvent {}

// Save updated contact event.
final class ContactEdit extends ContactEvent {}

// Delete contact event.
final class ContactRemove extends ContactEvent {}

// Change status event.
final class CreateContactStatusChange extends ContactEvent {
  final AddContactStatus status;

  const CreateContactStatusChange({required this.status});
}

final class UpdateContactStatusChange extends ContactEvent {
  final UpdateContactStatus status;

  const UpdateContactStatusChange({required this.status});
}

final class ChangeDeleteContactStatus extends ContactEvent {
  final DeleteContactStatus status;

  const ChangeDeleteContactStatus({required this.status});
}
