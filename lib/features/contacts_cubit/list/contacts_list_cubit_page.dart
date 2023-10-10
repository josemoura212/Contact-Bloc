import 'package:contact_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contact_bloc/features/contacts_cubit/register/contact_register_cubit_page.dart';
import 'package:contact_bloc/features/contacts_cubit/update/contact_cubit_update.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsListCubitPage extends StatelessWidget {
  const ContactsListCubitPage({Key? key}) : super(key: key);

  static const nameRoute = "/contacts/cubit/list";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Cubit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final contactList = context.read<ContactListCubit>();
          await Navigator.pushNamed(
              context, ContactRegisterCubitPage.nameRoute);
          contactList.findAll();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ContactListCubit>().findAll(),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: BlocListener<ContactListCubit, ContactListCubitState>(
                listenWhen: (previous, current) {
                  return current.maybeWhen(
                    error: (_) => true,
                    orElse: () => false,
                  );
                },
                listener: (context, state) {
                  state.whenOrNull(
                    error: (message) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Loader<ContactListCubit, ContactListCubitState>(
                      selector: (state) {
                        return state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                      },
                    ),
                    BlocSelector<ContactListCubit, ContactListCubitState,
                        List<ContactModel>>(
                      selector: (state) {
                        return state.maybeWhen(
                          data: (contacts) => contacts,
                          orElse: () => <ContactModel>[],
                        );
                      },
                      builder: (context, contacts) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: contacts.length,
                          itemBuilder: (_, index) {
                            final contact = contacts[index];
                            return ListTile(
                              title: Text(contact.name),
                              subtitle: Text(contact.email),
                              trailing: IconButton(
                                onPressed: () async {
                                  confirmDeleteContact(context).then((value) {
                                    if (value!) {
                                      context
                                          .read<ContactListCubit>()
                                          .deleteByModel(model: contact);
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              onTap: () async {
                                final contactList =
                                    context.read<ContactListCubit>();
                                await Navigator.pushNamed(
                                    context, ContactCubitUpdate.nameRoute,
                                    arguments: contact);
                                contactList.findAll();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool?> confirmDeleteContact(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tem certeza?"),
        content: const Text("Quer remover o contato?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Não"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Sim"),
          ),
        ],
      ),
    );
  }
}
