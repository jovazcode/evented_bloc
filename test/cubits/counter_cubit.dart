import 'package:evented_bloc/evented_bloc.dart';

enum CounterEvent { incremented, decremented }

class CounterCubit extends EventedCubit<CounterEvent, int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
    fireEvent(CounterEvent.incremented);
  }

  void decrement() {
    emit(state - 1);
    fireEvent(CounterEvent.decremented);
  }
}
