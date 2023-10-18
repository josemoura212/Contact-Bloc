import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts/register/bloc/contact_register_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  //declaraçao
  late MockContactsRepository repository;
  late ContactRegisterBloc bloc;
  late List<ContactModel> contacts;
  final contact1 =
      ContactModel(name: "José Augusto", email: "josemoura212@gmail.com");
  final contact2 = ContactModel(
      name: "Poliana Ribeiro", email: "polianaribeirogomes@gmail.com");
  final contact3 = ContactModel(
      name: "Poliana Ribeiro Gomes", email: "polianaribeirogomes@gmail.com");

  //preparaçao
  setUp(() {
    repository = MockContactsRepository();
    bloc = ContactRegisterBloc(repository: repository);
    contacts = [
      contact1,
      contact2,
    ];
  });
  //execução

  blocTest(
    "Deve salvar 1 contato",
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactRegisterEvent.save(
        name: "Poliana Ribeiro Gomes", email: "polianaribeirogomes@gmail.com")),
    setUp: () {
      contacts.add(contact3);
      when(() => repository.create(contact3)).thenAnswer((_) async => contacts);
    },
    expect: () {
      contacts.add(contact3);
      return [
        const ContactRegisterState.loading(),
        const ContactRegisterState.success(),
      ];
    },
  );
}
