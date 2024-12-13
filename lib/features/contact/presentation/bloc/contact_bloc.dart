import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trie/trie.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/contact.dart';
import '../../domain/entities/contact.dart';
import '../../domain/usecases/create_contact.dart';
import '../../domain/usecases/delete_contact.dart';
import '../../domain/usecases/load_contacts.dart';
import '../../domain/usecases/load_search_data.dart';
import '../../domain/usecases/search_contacts.dart';
import '../../domain/usecases/update_contact.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final LoadContacts _loadContacts;
  final LoadSearchData _loadSearchData;
  final SearchContacts _searchContacts;
  final CreateContact _createContact;
  final UpdateContact _updateContact;
  final DeleteContact _deleteContact;

  Trie? trie;

  ContactBloc(
      {required LoadContacts loadContacts,
      required SearchContacts searchContacts,
      required LoadSearchData loadSearchData,
      required CreateContact createContact,
      required UpdateContact updateContact,
      required DeleteContact deleteContact})
      : _loadContacts = loadContacts,
        _searchContacts = searchContacts,
        _loadSearchData = loadSearchData,
        _createContact = createContact,
        _updateContact = updateContact,
        _deleteContact = deleteContact,
        super(const ContactState()) {
    on<ContactLoad>(_onLoadContact);
    on<SearchInit>(_onSearchInit);
    on<SearchChange>(_onSearchChange);
    on<ContactSearch>(_onSearchContact);
    on<ContactChange>(_onContactChange);
    on<ContactAdd>(_onContactAdd);
    on<CreateContactStatusChange>(_onAddContactStatusChange);
    on<UpdateDataChange>(_onUpdateDataChange);
    on<ContactEdit>(_onContactEdit);
    on<UpdateContactStatusChange>(_onUpdateContactStatusChange);
    on<ContactRemove>(_onContactRemove);
  }

  void _onLoadContact(
    ContactLoad event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(contactStatus: ContactStatus.loading));

    final res = await _loadContacts(event.page);

    res.fold(
      (failure) => emit(state.copyWith(
          contactStatus: ContactStatus.failure, message: failure.message)),
      (contacts) => emit(state.copyWith(
          contactSearchStatus: ContactSearchStatus.initial,
          contactStatus: ContactStatus.success,
          currentPage: event.page,
          contacts:
              event.page == 1 ? contacts : [...state.contacts, ...contacts])),
    );
  }

  void _onSearchInit(
    SearchInit event,
    Emitter<ContactState> emit,
  ) async {
    final res = await _loadSearchData(NoParams());

    res.fold(
      (failure) => emit(state.copyWith(
          contactStatus: ContactStatus.failure, message: failure.message)),
      (searchData) {
        trie = Trie(root: TrieNode());
        Map<String, List<int>> dictMap = {};

        // build trie.
        for (int i = 0; i < searchData.length; i++) {
          List<String> splitWords = searchData[i].name.toLowerCase().split(' ');
          // remove duplicate words.
          List<String> keys = [
            ...{...splitWords}
          ];
          for (String key in keys) {
            // insert keywords.
            if (dictMap.containsKey(key)) {
              dictMap[key]!.add(searchData[i].id);
            } else {
              dictMap[key] = [searchData[i].id];
              trie!.insert(key);
            }
          }
        }
        emit(state.copyWith(dictionaryMap: dictMap));
      },
    );
  }

  void _onSearchChange(
    SearchChange event,
    Emitter<ContactState> emit,
  ) {
    if (trie == null) {
      return;
    }

    emit(state.copyWith(suggestionStatus: SuggestionStatus.loading));

    List<String> suggestions = [];

    if (event.keywords.trim().isEmpty) {
      return emit(state.copyWith(
          suggestions: suggestions,
          suggestionStatus: SuggestionStatus.initial));
    }

    List<String> splitWords = event.keywords.split(' ');

    if (splitWords.last.trim().isEmpty) {
      return emit(state.copyWith(
          suggestions: suggestions,
          suggestionStatus: SuggestionStatus.initial));
    }

    List<String> foughtWords = trie!.suggest(splitWords.last.toLowerCase());

    suggestions = splitWords.length > 1
        ? List<String>.from(
            foughtWords.map((x) => '...${x[0].toUpperCase()}${x.substring(1)}'))
        : List<String>.from(
            foughtWords.map((x) => '${x[0].toUpperCase()}${x.substring(1)}'));

    return emit(state.copyWith(
        suggestions: suggestions, suggestionStatus: SuggestionStatus.loaded));
  }

  void _onSearchContact(
    ContactSearch event,
    Emitter<ContactState> emit,
  ) async {
    if (trie == null) {
      return;
    }

    emit(state.copyWith(contactStatus: ContactStatus.loading));

    List<int> idList = [];

    for (String key in event.keywords) {
      List<String> words = trie!.suggest(key.toLowerCase());
      for (String word in words) {
        idList = [...idList, ...state.dictionaryMap[word]!];
      }
    }

    idList = [
      ...{...idList}
    ];

    final res = await _searchContacts(idList);

    res.fold(
      (failure) => emit(state.copyWith(
          contactStatus: ContactStatus.failure, message: failure.message)),
      (contacts) => emit(state.copyWith(
          contactStatus: ContactStatus.initial,
          contactSearchStatus: ContactSearchStatus.loaded,
          currentPage: 0,
          contacts: contacts)),
    );
  }

  void _onContactChange(
    ContactChange event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(contact: event.contact));
  }

  void _onContactAdd(
    ContactAdd event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(addContactStatus: AddContactStatus.loading));

    try {
      print(state.contact);
      final res = await _createContact(state.contact);
      res.fold(
        (failure) => emit(state.copyWith(
            addContactStatus: AddContactStatus.failure,
            message: failure.message)),
        (contact) {
          Map<String, List<int>> dictMap = state.dictionaryMap;
          if (trie == null) {
            trie = Trie(root: TrieNode());
            dictMap = {};
          }

          List<String> splitWords = contact.name.toLowerCase().split(' ');
          List<String> keys = [
            ...{...splitWords}
          ];
          for (String key in keys) {
            // insert keywords.
            if (dictMap.containsKey(key)) {
              dictMap[key]!.add(contact.id);
            } else {
              dictMap[key] = [contact.id];
              trie!.insert(key);
            }
          }

          emit(state.copyWith(
            dictionaryMap: dictMap,
            contacts: [...state.contacts, contact],
            addContactStatus: AddContactStatus.success,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          suggestions: const [],
          addContactStatus: AddContactStatus.failure,
          message: e.toString()));
    }
  }

  void _onAddContactStatusChange(
    CreateContactStatusChange event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(addContactStatus: event.status));
  }

  void _onUpdateDataChange(
    UpdateDataChange event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(updateData: event.contact));
  }

  void _onContactEdit(
    ContactEdit event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(updateContactStatus: UpdateContactStatus.loading));

    try {
      List<ContactEntity> contacts = state.contacts;
      ContactModel updatedContact = ContactModel.fromEntity(state.updateData)
          .copyWith(id: state.contact.id);
      final res = await _updateContact(updatedContact);
      res.fold(
        (failure) => emit(state.copyWith(
            updateContactStatus: UpdateContactStatus.failure,
            message: failure.message)),
        (contact) {
          int index =
              contacts.indexWhere((contact) => contact.id == state.contact.id);
          contacts[index] = contact;
          emit(state.copyWith(
            contacts: contacts,
            updateContactStatus: UpdateContactStatus.success,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          suggestions: const [],
          updateContactStatus: UpdateContactStatus.failure,
          message: e.toString()));
    }
  }

  void _onUpdateContactStatusChange(
    UpdateContactStatusChange event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(updateContactStatus: event.status));
  }

  void _onContactRemove(
    ContactRemove event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(deleteContactStatus: DeleteContactStatus.initial));

    try {
      List<ContactEntity> contacts = state.contacts;
      contacts.removeWhere((contact) => contact.id == state.contact.id);
      final res = await _deleteContact(state.contact.id);
      res.fold(
        (failure) => emit(state.copyWith(
            deleteContactStatus: DeleteContactStatus.failure,
            message: failure.message)),
        (message) => emit(state.copyWith(
          contacts: contacts,
          contact: ContactModel.empty,
          deleteContactStatus: DeleteContactStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
          suggestions: const [],
          addContactStatus: AddContactStatus.failure,
          message: e.toString()));
    }
  }
}
