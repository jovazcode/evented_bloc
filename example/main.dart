// ignore_for_file: avoid_print

import 'dart:async';

import 'package:evented_bloc/evented_bloc.dart';

class SimpleBlocObserver extends EventedBlocObserver {
  const SimpleBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    print('onCreate -- bloc: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    print('onChange -- bloc: ${bloc.runtimeType}, change: $change');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print('onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print('onError -- bloc: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    print('onClose -- bloc: ${bloc.runtimeType}');
  }

  @override
  void onFireEvent(EventedMixin<dynamic, dynamic> bloc, Object? event) {
    super.onFireEvent(bloc, event);
    print('onFireEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }
}

void main() {
  Bloc.observer = const SimpleBlocObserver();
  cubitMain();
  blocMain();
}

void cubitMain() {
  print('----------CUBIT----------');

  /// Create a `CounterCubit` instance.
  final cubit = CounterCubit();

  /// Access the state of the `cubit` via `state`.
  print(cubit.state); // 0

  /// Interact with the `cubit` to trigger `state` changes.
  cubit.increment();

  /// Access the new `state`.
  print(cubit.state); // 1

  /// Close the `cubit` when it is no longer needed.
  cubit.close();
}

Future<void> blocMain() async {
  print('----------BLOC----------');

  /// Create a `CounterBloc` instance.
  final bloc = CounterBloc();

  /// Access the state of the `bloc` via `state`.
  print(bloc.state);

  /// Interact with the `bloc` to trigger `state` changes.
  bloc.add(CounterDecrementPressed());

  /// Wait for next iteration of the event-loop
  /// to ensure event has been processed.
  await Future<void>.delayed(Duration.zero);

  /// Access the new `state`.
  print(bloc.state);

  /// Interact with the `bloc` to trigger `state` changes.
  bloc.add(CounterIncrementPressed());

  /// Wait for next iteration of the event-loop
  /// to ensure event has been processed.
  await Future<void>.delayed(Duration.zero);

  /// Access the new `state`.
  print(bloc.state);

  /// Close the `bloc` when it is no longer needed.
  await bloc.close();
}

/// A `CounterCubit` which manages an `int` as its state.
class CounterCubit extends EventedCubit<CounterEvent, int> {
  /// The initial state of the `CounterCubit` is 0.
  CounterCubit() : super(0);

  /// When increment is called, the current state
  /// of the cubit is accessed via `state` and
  /// a new `state` is emitted via `emit`.
  void increment() => emit(state + 1);
}

/// The events which `CounterBloc` will react to.
abstract class CounterEvent {}

/// Notifies bloc to increment state.
class CounterIncrementPressed extends CounterEvent {
  @override
  String toString() {
    return 'CounterIncrementPressed';
  }
}

/// Notifies bloc to decrement state.
class CounterDecrementPressed extends CounterEvent {
  @override
  String toString() {
    return 'CounterDecrementPressed';
  }
}

/// {@template min_count_value_reached}
/// Notifies when bloc prevents counter from going below min value.
/// {@endtemplate}
class MinCountValueReached extends CounterEvent {
  /// {@macro min_count_value_reached}
  MinCountValueReached([this.value = 0]);

  final int value;

  @override
  String toString() {
    return 'MinCountValueReached { value: $value }';
  }
}

/// {@template max_count_value_reached}
/// Notifies when bloc prevents counter from exceeding max value.
/// {@endtemplate}
class MaxCountValueReached extends CounterEvent {
  /// {@macro max_count_value_reached}
  MaxCountValueReached([this.value = 10]);

  final int value;

  @override
  String toString() {
    return 'MaxCountValueReached { value: $value }';
  }
}

/// A `CounterBloc` which handles converting `CounterEvent`s into `int`s.
///
/// The bloc prevents the counter from going below 0,
/// and from exceeding 10.
class CounterBloc extends EventedBloc<CounterEvent, int> {
  /// The initial state of the `CounterBloc` is 0.
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) {
      if (state == 10) {
        fireEvent(MaxCountValueReached());
        return;
      }
      emit(state + 1);
    });
    on<CounterDecrementPressed>((event, emit) {
      if (state == 0) {
        fireEvent(MinCountValueReached());
        return;
      }
      emit(state - 1);
    });
  }
}
