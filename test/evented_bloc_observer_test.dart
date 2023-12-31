import 'package:evented_bloc/evented_bloc.dart';
import 'package:test/test.dart';

import 'blocs/blocs.dart';

class DefaultBlocObserver extends EventedBlocObserver {
  const DefaultBlocObserver();
}

void main() {
  final bloc = CounterBloc(forwardEvents: true);
  const event = CounterEvent.increment;
  group('EventedBlocObserver', () {
    group('onFireEvent', () {
      test('does nothing by default', () {
        // ignore: invalid_use_of_protected_member
        const DefaultBlocObserver().onFireEvent(bloc, event);
      });
    });
  });
}
