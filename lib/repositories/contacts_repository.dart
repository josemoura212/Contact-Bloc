import 'package:contact_bloc/models/contact_model.dart';
import 'package:dio/dio.dart';

class ContactsRepository {
  final String _url = "http://localhost:8080/contacts";
  Future<List<ContactModel>> findAll() async {
    final Response(data: data as List) = await Dio().get(_url);

    return data
        .map<ContactModel>((contact) => ContactModel.fromMap(contact))
        .toList();
  }

  Future<void> create(ContactModel model) =>
      Dio().post(_url, data: model.toMap());

  Future<void> update(ContactModel model) =>
      Dio().put("$_url/${model.id}", data: model.toMap());

  Future<void> delete(ContactModel model) => Dio().delete("$_url/${model.id}");
}
