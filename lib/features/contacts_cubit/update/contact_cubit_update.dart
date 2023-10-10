import 'package:contact_bloc/features/contacts_cubit/update/cubit/contact_update_cubit.dart';
import 'package:contact_bloc/models/contact_model.dart';
import 'package:contact_bloc/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCubitUpdate extends StatefulWidget {
  final ContactModel contact;
  const ContactCubitUpdate({
    Key? key,
    required this.contact,
  }) : super(key: key);

  static const nameRoute = "/contacts/cubit/update";

  @override
  State<ContactCubitUpdate> createState() => _ContactCubitUpdateState();
}

class _ContactCubitUpdateState extends State<ContactCubitUpdate> {
  late TextEditingController _nameEC;
  late TextEditingController _emailEC;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameEC = TextEditingController(text: widget.contact.name);
    _emailEC = TextEditingController(text: widget.contact.email);
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _nameEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Cubit Register'),
      ),
      body: BlocListener<ContactUpdateCubit, ContactUpdateStateCubit>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            success: () => true,
            error: (message) => true,
            orElse: () => false,
          );
        },
        listener: (context, state) {
          state.maybeWhen(
            success: () => Navigator.pop(context),
            error: (_) => true,
            orElse: () => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
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
                      context.read<ContactUpdateCubit>().update(
                              model: ContactModel(
                            id: widget.contact.id,
                            name: _nameEC.text,
                            email: _emailEC.text,
                          ));
                    }
                  },
                  child: const Text("Salvar"),
                ),
                Loader<ContactUpdateCubit, ContactUpdateStateCubit>(
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
