import 'package:contact_bloc/features/bloc_example/bloc/example_bloc.dart';
import 'package:contact_bloc/features/bloc_example/bloc_example.dart';
import 'package:contact_bloc/features/bloc_example/bloc_freezed/example_freezed_bloc.dart';
import 'package:contact_bloc/features/bloc_example/bloc_freezed_example.dart';
import 'package:contact_bloc/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:contact_bloc/features/contacts/list/contacts_list_page.dart';
import 'package:contact_bloc/features/contacts/register/bloc/contact_register_bloc.dart';
import 'package:contact_bloc/features/contacts/register/contact_register_page.dart';
import 'package:contact_bloc/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:contact_bloc/features/contacts_cubit/list/contacts_list_cubit_page.dart';
import 'package:contact_bloc/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:contact_bloc/features/contacts_cubit/register/contact_register_cubit_page.dart';
import 'package:contact_bloc/features/contacts_cubit/register/cubit/contact_register_cubit.dart';
import 'package:contact_bloc/features/contacts_cubit/update/contact_cubit_update.dart';
import 'package:contact_bloc/features/contacts_cubit/update/cubit/contact_update_cubit.dart';
import 'package:contact_bloc/home/home_page.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/repositories/contacts_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/contacts/update/contact_update_page.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ContactsRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Contact Bloc",
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        scrollBehavior: MyCustomScrollBehavior(),
        initialRoute: "/",
        routes: {
          HomePage.nameRoute: (_) => const HomePage(),
          BlocExample.nameRoute: (_) => BlocProvider(
                create: (_) => ExampleBloc()..add(ExampleFindNameEvent()),
                child: const BlocExample(),
              ),
          BlocFreezedExample.nameRoute: (_) => BlocProvider(
              create: (_) =>
                  ExampleFreezedBloc()..add(ExampleFreezedEvent.findNames()),
              child: const BlocFreezedExample()),
          ContactsListPage.nameRoute: (_) => BlocProvider(
                create: (context) => ContactListBloc(
                    repository: context.read<ContactsRepository>())
                  ..add(
                    const ContactListEvent.findAll(),
                  ),
                child: const ContactsListPage(),
              ),
          ContactRegisterPage.nameRoute: (_) => BlocProvider(
                create: (context) => ContactRegisterBloc(
                    repository: context.read<ContactsRepository>()),
                child: const ContactRegisterPage(),
              ),
          ContactUpdatePage.nameRoute: (context) {
            final model =
                ModalRoute.of(context)!.settings.arguments as ContactModel;
            return BlocProvider(
              create: (context) => ContactUpdateBloc(
                repository: context.read<ContactsRepository>(),
              ),
              child: ContactUpdatePage(contact: model),
            );
          },
          ContactsListCubitPage.nameRoute: (context) => BlocProvider(
              create: (context) => ContactListCubit(
                  repository: context.read<ContactsRepository>())
                ..findAll(),
              child: const ContactsListCubitPage()),
          ContactRegisterCubitPage.nameRoute: (context) => BlocProvider(
                create: (context) => ContactRegisterCubit(
                  repository: context.read<ContactsRepository>(),
                ),
                child: const ContactRegisterCubitPage(),
              ),
          ContactCubitUpdate.nameRoute: (context) {
            final contact =
                ModalRoute.of(context)!.settings.arguments as ContactModel;

            return BlocProvider(
              create: (context) => ContactUpdateCubit(
                repository: context.read<ContactsRepository>(),
              ),
              child: ContactCubitUpdate(contact: contact),
            );
          }
        },
      ),
    );
  }
}
