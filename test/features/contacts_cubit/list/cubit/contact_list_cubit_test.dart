import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  //declaraçao
  late MockContactsRepository repository;
  late ContactListCubit cubit;
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
    cubit = ContactListCubit(repository: repository);
    contacts = [
      contact1,
      contact2,
      contact3,
    ];
  });
  //execução
  blocTest<ContactListCubit, ContactListCubitState>(
    "Deve buscar os contatos",
    build: () => cubit,
    act: (cubit) => cubit.findAll(),
    setUp: () {
      when(() => repository.findAll()).thenAnswer((_) async => contacts);
    },
    expect: () => [
      const ContactListCubitState.loading(),
      ContactListCubitState.data(contacts: contacts),
    ],
  );
  blocTest<ContactListCubit, ContactListCubitState>(
    "Deve deletar 1 contato",
    build: () => cubit,
    act: (cubit) => cubit.deleteByModel(model: contact1),
    setUp: () {
      contacts.remove(contact1);
      when(() => repository.delete(contact1)).thenAnswer((_) async => contacts);
      when(() => repository.findAll()).thenAnswer((_) async => contacts);
    },
    expect: () {
      contacts.remove(contact1);
      return [
        const ContactListCubitState.loading(),
        ContactListCubitState.data(contacts: contacts),
      ];
    },
  );
  blocTest<ContactListCubit, ContactListCubitState>("Deve deletar 1 contato",
      build: () => cubit,
      act: (cubit) => cubit.deleteByModel(model: contact3),
      setUp: () {
        contacts.remove(contact3);
        when(() => repository.delete(contact3))
            .thenAnswer((_) async => contacts);
        when(() => repository.findAll()).thenAnswer((_) async => contacts);
      },
      expect: () {
        contacts.remove(contact3);
        return [
          const ContactListCubitState.loading(),
          ContactListCubitState.data(contacts: contacts),
        ];
      });
}
