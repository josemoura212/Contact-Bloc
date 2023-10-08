import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';
part "contact_list_bloc.freezed.dart";

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactsRepository _repository;
  ContactListBloc({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactListState.inital()) {
    on<_ContactListEventFindAll>(_findAll);
    on<_Delete>(_delete);
  }

  FutureOr<void> _findAll(
    _ContactListEventFindAll event,
    Emitter<ContactListState> emit,
  ) async {
    try {
      emit(const ContactListState.loading());
      final contacts = await _repository.findAll();
      emit(ContactListState.data(contacts: contacts));
    } catch (e, s) {
      log("Erro ao buscar contatos", error: e, stackTrace: s);
      emit(const ContactListState.error(error: "Erro ao buscar contatos"));
    }
  }

  Future<FutureOr<void>> _delete(
      _Delete event, Emitter<ContactListState> emit) async {
    try {
      emit(const ContactListState.loading());
      await _repository.delete(event.model);
      add(const ContactListEvent.findAll());
      final contacts = await _repository.findAll();
      emit(ContactListState.data(contacts: contacts));
    } catch (e, s) {
      log("Erro ao deletar contato", error: e, stackTrace: s);
      emit(const ContactListState.error(error: "Erro ao deletar contato"));
    }
  }
}
