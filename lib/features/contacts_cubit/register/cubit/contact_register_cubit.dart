import 'dart:developer';

import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_register_cubit_state.dart';
part 'contact_register_cubit.freezed.dart';

class ContactRegisterCubit extends Cubit<ContactRegisterCubitState> {
  final ContactsRepository _repository;
  ContactRegisterCubit({required ContactsRepository repository})
      : _repository = repository,
        super(const _Inital());

  Future<void> save({required ContactModel model}) async {
    try {
      emit(const _Loading());
      await _repository.create(model);
      emit(const _Success());
    } catch (e, s) {
      log("Erro ao cadastrar contato", error: e, stackTrace: s);
      emit(const _Error(message: "Erro ao cadastrar contato"));
    }
  }
}
