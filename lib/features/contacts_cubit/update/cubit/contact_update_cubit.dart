import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_update_state.dart';
part 'contact_update_cubit.freezed.dart';

class ContactUpdateCubit extends Cubit<ContactUpdateStateCubit> {
  final ContactsRepository _repository;
  ContactUpdateCubit({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactUpdateStateCubit.initial());

  Future<void> update({required ContactModel model}) async {
    try {
      emit(const _Loading());
      await _repository.update(model);
      emit(const _Success());
    } catch (e, s) {
      log("Erro ao atualizar contato", error: e, stackTrace: s);
      emit(const _Error(message: "Erro ao atulizar contato"));
    }
  }
}
