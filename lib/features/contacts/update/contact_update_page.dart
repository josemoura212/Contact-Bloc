import 'package:contact_bloc/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUpdatePage extends StatefulWidget {
  final ContactModel contact;
  const ContactUpdatePage({
    Key? key,
    required this.contact,
  }) : super(key: key);
  static const nameRoute = "/contacts/update";

  @override
  State<ContactUpdatePage> createState() => _ContactUpdatePageState();
}

class _ContactUpdatePageState extends State<ContactUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailEC;
  late final TextEditingController _nameEC;

  @override
  void initState() {
    super.initState();
    _nameEC = TextEditingController(text: widget.contact.name);
    _emailEC = TextEditingController(text: widget.contact.email);
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Update'),
      ),
      body: BlocListener<ContactUpdateBloc, ContactUpdateState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            success: () => true,
            error: (_) => true,
            orElse: () => false,
          );
        },
        listener: (context, state) {
          state.whenOrNull(
            success: () => Navigator.pop(context),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameEC,
                  decoration: const InputDecoration(
                    label: Text("Nome"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nome é Obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailEC,
                  decoration: const InputDecoration(
                    label: Text("E-mail"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "E-mail é Obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    final validate = _formKey.currentState?.validate() ?? false;
                    if (validate) {
                      context.read<ContactUpdateBloc>().add(
                            ContactUpdateEvent.save(
                              id: widget.contact.id!,
                              name: _nameEC.text,
                              email: _emailEC.text,
                            ),
                          );
                    }
                  },
                  child: const Text("Salvar"),
                ),
                Loader<ContactUpdateBloc, ContactUpdateState>(
                  selector: (state) {
                    return state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
