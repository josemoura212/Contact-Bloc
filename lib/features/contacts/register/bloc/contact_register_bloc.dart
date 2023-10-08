import 'dart:async';
import 'dart:developer';

import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_register_state.dart';
part 'contact_register_event.dart';
part 'contact_register_bloc.freezed.dart';

class ContactRegisterBloc
    extends Bloc<ContactRegisterEvent, ContactRegisterState> {
  final ContactsRepository _repository;
  ContactRegisterBloc({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactRegisterState.initial()) {
    on<_Save>(_save);
  }

  FutureOr<void> _save(_Save event, Emitter<ContactRegisterState> emit) async {
    try {
      emit(const ContactRegisterState.loading());
      final model = ContactModel(
        name: event.name,
        email: event.email,
      );

      await _repository.create(model);
      emit(const ContactRegisterState.success());
    } catch (e, s) {
      log("Erro ao salvar um novo contato", error: e, stackTrace: s);
      emit(const ContactRegisterState.error(
          message: "Erro ao salvar um novo contato"));
    }
  }
}
