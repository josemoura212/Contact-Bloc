import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_list_cubit_state.dart';
part 'contact_list_cubit.freezed.dart';

class ContactListCubit extends Cubit<ContactListCubitState> {
  final ContactsRepository _repository;
  ContactListCubit({required ContactsRepository repository})
      : _repository = repository,
        super(const _Initial());

  Future<void> findAll() async {
    try {
      emit(const _Loading());
      final contacts = await _repository.findAll();
      // await Future.delayed(const Duration(seconds: 1));
      emit(_Data(contacts: contacts));
    } catch (e, s) {
      log("Erro ao buscar contatos", error: e, stackTrace: s);
      emit(const _Error(message: "Erro ao buscar contatos"));
    }
  }

  Future<void> deleteByModel({required ContactModel model}) async {
    emit(const _Loading());
    await _repository.delete(model);
    findAll();
  }
}
