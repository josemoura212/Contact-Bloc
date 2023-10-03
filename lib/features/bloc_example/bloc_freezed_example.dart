import 'package:contact_bloc/features/bloc_example/bloc_freezed/example_freezed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocFreezedExample extends StatelessWidget {
  const BlocFreezedExample({Key? key}) : super(key: key);
  static const nameRoute = "/bloc/example/freezed";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Freezed'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<ExampleFreezedBloc>()
              .add(ExampleFreezedEvent.addName("Novo nome Freezed"));
        },
      ),
      body: BlocListener<ExampleFreezedBloc, ExampleFreezedState>(
        listener: (context, state) {
          state.whenOrNull(
            showBanner: (_, message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            },
          );
        },
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child:
                  BlocSelector<ExampleFreezedBloc, ExampleFreezedState, bool>(
                selector: (state) {
                  return state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );
                },
                builder: (_, showLoader) {
                  if (showLoader) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            BlocSelector<ExampleFreezedBloc, ExampleFreezedState, List<String>>(
              selector: (state) {
                return state.maybeWhen(
                  data: (names) => names,
                  showBanner: (names, _) => names,
                  orElse: () => <String>[],
                );
              },
              builder: (_, names) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: names.length,
                  itemBuilder: (_, index) {
                    final name = names[index];
                    return ListTile(
                      title: Text(name),
                      onTap: () {
                        context
                            .read<ExampleFreezedBloc>()
                            .add(ExampleFreezedEvent.removeName(name));
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
