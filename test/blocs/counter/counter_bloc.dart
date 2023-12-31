import 'package:evented_bloc/evented_bloc.dart';

typedef OnEventCallback = void Function(CounterEvent);
typedef OnTransitionCallback = void Function(Transition<CounterEvent, int>);
typedef OnErrorCallback = void Function(Object error, StackTrace? stackTrace);

enum CounterEvent { increment, decrement, incremented, decremented }

class CounterBloc extends EventedBloc<CounterEvent, int> {
  CounterBloc({super.forwardEvents}) : super(0) {
    on<CounterEvent>(_onCounterEvent);
  }

  void _onCounterEvent(CounterEvent event, Emitter<int> emit) {
    if (event == CounterEvent.increment) {
      emit(state + 1);
      return fireEvent(CounterEvent.incremented);
    } else if (event == CounterEvent.decrement) {
      emit(state - 1);
      return fireEvent(CounterEvent.decremented);
    }
  }
}
