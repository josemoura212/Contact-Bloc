import 'package:contact_bloc/features/bloc_example/bloc_example.dart';
import 'package:flutter/material.dart';

import '../features/bloc_example/bloc_freezed_example.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const nameRoute = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Wrap(
            children: [
              _ButtonCard(
                label: "Example",
                routeName: BlocExample.nameRoute,
              ),
              _ButtonCard(
                label: "Example Freezed",
                routeName: BlocFreezedExample.nameRoute,
              ),
              _ButtonCard(
                label: "Contact",
                routeName: BlocExample.nameRoute,
              ),
              _ButtonCard(
                label: "Contact Cubit",
                routeName: BlocExample.nameRoute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonCard extends StatelessWidget {
  final String label;
  final String routeName;
  const _ButtonCard({
    required this.label,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        elevation: 16,
        shadowColor: Colors.black,
        margin: const EdgeInsets.all(5),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
