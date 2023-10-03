import 'package:contact_bloc/models/contact_model.dart';
import 'package:dio/dio.dart';

class ContactsRepository {
  final String url = "http://localhost:3031/contacts";
  Future<List<ContactModel>> findAll() async {
    final Response(data: data as List) = await Dio().get(url);

    return data
        .map<ContactModel>((contact) => ContactModel.fromMap(contact))
        .toList();
  }

  Future<void> create(ContactModel model) =>
      Dio().post(url, data: model.toMap());

  Future<void> update(ContactModel model) =>
      Dio().put("$url/${model.id}", data: model.toMap());

  Future<void> delete(ContactModel model) => Dio().delete("$url/${model.id}");
}
