import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc() : super(ExampleStateInitial()) {
    on<ExampleFindNameEvent>(_findNames);
  }

  Future<void> _findNames(
    ExampleFindNameEvent event,
    Emitter<ExampleState> emit,
  ) async {
    final names = [
      "José Augusto",
      "Poliana Ribeiro",
      "Safira",
      "Hanna",
      "Henrique Augusto",
      "Manuela Ribeiro",
    ];

    emit(ExampleStateData(names: names));
  }
}
