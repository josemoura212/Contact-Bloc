import 'package:bloc_test/bloc_test.dart';
import 'package:contact_bloc/features/contacts_cubit/register/cubit/contact_register_cubit.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  //declaraçao
  late MockContactsRepository repository;
  late ContactRegisterCubit cubit;
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
    cubit = ContactRegisterCubit(repository: repository);
    contacts = [
      contact1,
      contact2,
    ];
  });
  //execução
  blocTest(
    "Deve registrar 1 contato",
    build: () => cubit,
    act: (cubit) => cubit.save(model: contact3),
    setUp: () {
      contacts.add(contact3);
      when(() => repository.create(contact3)).thenAnswer((_) async => contacts);
    },
    expect: () => [
      const ContactRegisterCubitState.loading(),
      const ContactRegisterCubitState.success(),
    ],
  );
}
