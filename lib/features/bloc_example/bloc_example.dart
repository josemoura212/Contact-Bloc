import 'package:contact_bloc/features/bloc_example/bloc/example_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocExample extends StatelessWidget {
  const BlocExample({Key? key}) : super(key: key);

  static const nameRoute = "/bloc/example";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Example'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ExampleBloc>().add(
                ExampleAddNameEvent(name: "Teste"),
              );
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          child: const Icon(Icons.add),
        ),
      ),
      body: Center(
        child: BlocListener<ExampleBloc, ExampleState>(
          listener: (context, state) {
            if (state is ExampleStateData) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text("A quantidade de nomes e ${state.names.length}"),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<ExampleBloc, ExampleState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ExampleStateData) {
                    return Text("Total de nomes e ${state.names.length}");
                  }
                  return const SizedBox.shrink();
                },
              ),
              BlocSelector<ExampleBloc, ExampleState, bool>(
                selector: (state) {
                  if (state is ExampleStateInitial) return true;
                  return false;
                },
                builder: (context, showLoader) {
                  if (showLoader) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox.shrink();
                },
              ),
              BlocSelector<ExampleBloc, ExampleState, List<String>>(
                selector: (state) {
                  if (state is ExampleStateData) {
                    return state.names;
                  } else {
                    return [];
                  }
                },
                builder: (context, names) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      final name = names[index];
                      return ListTile(
                        title: Text(name),
                        onTap: () {
                          context.read<ExampleBloc>().add(
                                ExampleRemoveNameEvent(name: name),
                              );
                        },
                      );
                    },
                  );
                },
              ),
              // BlocBuilder<ExampleBloc, ExampleState>(
              //   builder: (context, state) {
              //     if (state is ExampleStateData) {
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: state.names.length,
              //         itemBuilder: (context, index) {
              //           final name = state.names[index];
              //           return ListTile(
              //             title: Text(name),
              //           );
              //         },
              //       );
              //     }
              //     return const SizedBox.shrink();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
