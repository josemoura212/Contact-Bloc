import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  //declaraçao
  late MockContactsRepository repository;
  late ContactUpdateBloc bloc;
  late List<ContactModel> contacts;
  final contact1 =
      ContactModel(name: "José Augusto", email: "josemoura212@gmail.com");
  final contact2 = ContactModel(
      name: "Poliana Ribeiro", email: "polianaribeirogomes@gmail.com");
  final contact3 = ContactModel(
      id: 1,
      name: "Poliana Ribeiro Gomes",
      email: "polianaribeirogomes@gmail.com");
  final contact4 = ContactModel(
      id: 1, name: "Poliana Ribeiro", email: "polianaribeirogomes@gmail.com");

  //preparaçao
  setUp(() {
    repository = MockContactsRepository();
    bloc = ContactUpdateBloc(repository: repository);
    contacts = [contact1, contact2, contact3];
  });
  //execução

  blocTest(
    "Deve atulizar um contato",
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactUpdateEvent.save(
        id: 1,
        name: "Poliana Ribeiro",
        email: "polianaribeirogomes@gmail.com")),
    setUp: () {
      contacts.remove(contact3);
      contacts.add(contact4);
      when(() => repository.update(contact4)).thenAnswer((_) async => contacts);
    },
    expect: () {
      contacts.remove(contact3);
      contacts.add(contact4);
      return [
        const ContactUpdateState.loading(),
        const ContactUpdateState.success(),
      ];
    },
  );
}
