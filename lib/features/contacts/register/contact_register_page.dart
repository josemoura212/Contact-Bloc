import 'package:flutter/material.dart';

class ContactRegisterPage extends StatelessWidget {
  const ContactRegisterPage({Key? key}) : super(key: key);

  static const nameRoute = "/contacts/register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Register'),
      ),
      body: Container(),
    );
  }
}
