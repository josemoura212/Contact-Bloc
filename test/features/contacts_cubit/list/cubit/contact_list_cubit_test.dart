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

  //preparaçao
  setUp(() {
    repository = MockContactsRepository();
    cubit = ContactListCubit(repository: repository);
    contacts = [
      ContactModel(name: "José Augusto", email: "josemoura212@gmail.com"),
      ContactModel(
          name: "Poliana Ribeiro", email: "polianaribeirogomes@gmail.com"),
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
}
