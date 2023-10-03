import 'package:contact_bloc/features/bloc_example/bloc/example_bloc.dart';
import 'package:contact_bloc/features/bloc_example/bloc_example.dart';
import 'package:contact_bloc/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Contact Bloc",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        HomePage.nameRoute: (_) => const HomePage(),
        BlocExample.nameRoute: (_) => BlocProvider(
              create: (_) => ExampleBloc(),
              child: const BlocExample(),
            ),
      },
    );
  }
}
