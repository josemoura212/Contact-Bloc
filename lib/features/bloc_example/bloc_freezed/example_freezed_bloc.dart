import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_freezed_state.dart';
part "example_freezed_bloc.freezed.dart";
part 'example_freezed_event.dart';

class ExampleFreezedBloc
    extends Bloc<ExampleFreezedEvent, ExampleFreezedState> {
  ExampleFreezedBloc() : super(ExampleFreezedState.initial()) {
    on<_ExampleFreezedEventFindNames>(_findNames);
    on<_ExampleFreezedEventRemoveName>(_removeName);
    on<_ExampleFreezedEventAddName>(_addName);
  }

  Future<FutureOr<void>> _addName(
    _ExampleFreezedEventAddName event,
    Emitter<ExampleFreezedState> emit,
  ) async {
    final names = state.maybeWhen(
      data: (names) => names,
      orElse: () => const <String>[],
    );
    emit(ExampleFreezedState.showBanner(
        names: names, message: "Aguarde, Nome sendo inserido!!!!"));
    await Future.delayed(const Duration(seconds: 2));

    names.add(event.name);
    emit(ExampleFreezedState.data(names: names));
  }

  FutureOr<void> _removeName(
    _ExampleFreezedEventRemoveName event,
    Emitter<ExampleFreezedState> emit,
  ) {
    final names = state.maybeWhen(
      data: (names) => names,
      orElse: () => const <String>[],
    );

    names.retainWhere((element) => element != event.name);
    emit(ExampleFreezedState.data(names: names));
  }

  FutureOr<void> _findNames(
    _ExampleFreezedEventFindNames event,
    Emitter<ExampleFreezedState> emit,
  ) async {
    emit(ExampleFreezedState.loading());
    final names = [
      "José Augusto",
      "Poliana Ribeiro",
      "Safira",
      "Hanna",
      "Henrique Augusto",
      "Manuela Ribeiro",
    ];
    await Future.delayed(const Duration(seconds: 4));
    emit(ExampleFreezedState.data(names: names));
  }
}
