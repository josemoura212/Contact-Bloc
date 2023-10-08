import 'package:contact_bloc/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:contact_bloc/features/contacts/register/contact_register_page.dart';
import 'package:contact_bloc/features/contacts/update/contact_update_page.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsListPage extends StatelessWidget {
  const ContactsListPage({Key? key}) : super(key: key);

  static const nameRoute = "/contacts/list";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ? solution
          Navigator.pushNamed(context, ContactRegisterPage.nameRoute).then(
            (value) => context
                .read<ContactListBloc>()
                .add(const ContactListEvent.findAll()),
          );
          //! lint not use context funciton async
          // BlocProvider.of<ContactListBloc>(context)
          //     .add(const ContactListEvent.findAll());
          // context.read<ContactListBloc>().add(const ContactListEvent.findAll());
        },
        child: const Icon(Icons.add),
      ),
      body: BlocListener<ContactListBloc, ContactListState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            error: (error) => true,
            orElse: () => false,
          );
        },
        listener: (context, state) {
          state.whenOrNull(
            error: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: RefreshIndicator(
          onRefresh: () async => context.read<ContactListBloc>()
            ..add(const ContactListEvent.findAll()),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loader<ContactListBloc, ContactListState>(
                      selector: (state) {
                        return state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                      },
                    ),
                    BlocSelector<ContactListBloc, ContactListState,
                        List<ContactModel>>(
                      selector: (state) {
                        return state.maybeWhen(
                          data: (contacts) => contacts,
                          orElse: () => [],
                        );
                      },
                      builder: (_, contacts) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: contacts.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            return Dismissible(
                              key: ValueKey(contact.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Tem certeza?"),
                                    content:
                                        const Text("Quer remover o contato?"),
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
                              },
                              onDismissed: (direction) {
                                context.read<ContactListBloc>().add(
                                    ContactListEvent.delete(model: contact));
                              },
                              child: ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ContactUpdatePage.nameRoute,
                                    arguments: contacts[index],
                                  ).then((value) => context
                                      .read<ContactListBloc>()
                                      .add(const ContactListEvent.findAll()));
                                },
                                title: Text(contact.name),
                                subtitle: Text(contact.email),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
