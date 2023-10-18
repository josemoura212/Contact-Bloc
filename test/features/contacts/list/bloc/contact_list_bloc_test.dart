import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  //declaraçao
  late MockContactsRepository repository;
  late ContactListBloc bloc;
  late List<ContactModel> contacts;
  final contact1 =
      ContactModel(name: "José Augusto", email: "josemoura212@gmail.com");
  final contact2 = ContactModel(
      name: "Poliana Ribeiro", email: "polianaribeirogomes@gmail.com");
  final contact3 = ContactModel(
      name: "Poliana Ribeiro", email: "polianaribeirogomes@gmail.com");

  //preparaçao
  setUp(() {
    repository = MockContactsRepository();
    bloc = ContactListBloc(repository: repository);
    contacts = [
      contact1,
      contact2,
      contact3,
    ];
  });
  //execução

  blocTest<ContactListBloc, ContactListState>(
    "Deve buscar os contatos",
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactListEvent.findAll()),
    setUp: () {
      when(() => repository.findAll()).thenAnswer((_) async => contacts);
    },
    expect: () => [
      const ContactListState.loading(),
      ContactListState.data(contacts: contacts),
    ],
  );
  blocTest<ContactListBloc, ContactListState>(
    "Deve buscar erros ao buscar contatos",
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactListEvent.findAll()),
    expect: () => [
      const ContactListState.loading(),
      const ContactListState.error(error: "Erro ao buscar contatos"),
    ],
  );
  blocTest<ContactListBloc, ContactListState>("Deve deletar 1 contato",
      build: () => bloc,
      act: (bloc) => bloc.add(ContactListEvent.delete(model: contact1)),
      setUp: () {
        contacts.remove(contact1);
        when(() => repository.delete(contact1))
            .thenAnswer((_) async => contacts);
        when(() => repository.findAll()).thenAnswer((_) async => contacts);
      },
      expect: () {
        contacts.remove(contact1);
        return [
          const ContactListState.loading(),
          ContactListState.data(contacts: contacts),
        ];
      });
}
