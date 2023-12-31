import 'package:evented_bloc/evented_bloc.dart';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'blocs/blocs.dart';

class MockBlocObserver extends Mock implements EventedBlocObserver {}

void main() {
  group('CounterBloc', () {
    late CounterBloc counterBloc;
    late MockBlocObserver observer;

    setUp(() {
      counterBloc = CounterBloc();
      observer = MockBlocObserver();
      Bloc.observer = observer;
    });

    test('state returns correct value initially', () {
      expect(counterBloc.state, 0);
    });

    test('single Increment event updates state to 1', () {
      final expectedStates = [1, emitsDone];
      final counterBloc = CounterBloc(forwardEvents: true);

      expectLater(
        counterBloc.stream,
        emitsInOrder(expectedStates),
      ).then((dynamic _) {
        verify(
          // ignore: invalid_use_of_protected_member
          () => observer.onFireEvent(
            counterBloc,
            CounterEvent.increment,
          ),
        ).called(1);
        verify(
          // ignore: invalid_use_of_protected_member
          () => observer.onFireEvent(
            counterBloc,
            CounterEvent.incremented,
          ),
        ).called(1);
        expect(counterBloc.state, 1);
      });

      counterBloc
        ..add(CounterEvent.increment)
        ..close();
    });

    test('multiple Increment event updates state to 3', () {
      final expectedStates = [1, 2, 3, emitsDone];
      final counterBloc = CounterBloc();

      expectLater(
        counterBloc.stream,
        emitsInOrder(expectedStates),
      ).then((dynamic _) {
        expect(counterBloc.state, 3);
      });

      counterBloc
        ..add(CounterEvent.increment)
        ..add(CounterEvent.increment)
        ..add(CounterEvent.increment)
        ..close();
    });

    test(
        'single Increment/Decrement event generates Incremented/Decremented event',
        () {
      final expectedEvents = [
        CounterEvent.incremented,
        CounterEvent.decremented,
        emitsDone,
      ];
      final counterBloc = CounterBloc();

      expectLater(
        counterBloc.eventStream,
        emitsInOrder(expectedEvents),
      ).then((dynamic _) {
        expect(counterBloc.state, 0);
      });

      counterBloc
        ..add(CounterEvent.increment)
        ..add(CounterEvent.decrement)
        ..close();
    });

    test('multiple Increment event generates multiple Incremented event', () {
      final expectedEvents = [
        CounterEvent.incremented,
        CounterEvent.incremented,
        CounterEvent.incremented,
        emitsDone,
      ];
      final counterBloc = CounterBloc();

      expectLater(
        counterBloc.eventStream,
        emitsInOrder(expectedEvents),
      ).then((dynamic _) {
        expect(counterBloc.state, 3);
      });

      counterBloc
        ..add(CounterEvent.increment)
        ..add(CounterEvent.increment)
        ..add(CounterEvent.increment)
        ..close();
    });

    test('is a broadcast stream', () {
      final expectedEvents = [
        CounterEvent.incremented,
        CounterEvent.decremented,
        emitsDone,
      ];

      expect(counterBloc.eventStream.isBroadcast, isTrue);
      expectLater(counterBloc.eventStream, emitsInOrder(expectedEvents));
      expectLater(counterBloc.eventStream, emitsInOrder(expectedEvents));

      counterBloc
        ..add(CounterEvent.increment)
        ..add(CounterEvent.decrement)
        ..close();
    });

    test('multiple subscribers receive the latest state', () {
      const expected = <int>[1];

      expectLater(counterBloc.stream, emitsInOrder(expected));
      expectLater(counterBloc.stream, emitsInOrder(expected));
      expectLater(counterBloc.stream, emitsInOrder(expected));

      counterBloc.add(CounterEvent.increment);
    });

    test('multiple subscribers receive the latest event', () {
      const expected = <CounterEvent>[CounterEvent.incremented];

      expectLater(counterBloc.eventStream, emitsInOrder(expected));
      expectLater(counterBloc.eventStream, emitsInOrder(expected));
      expectLater(counterBloc.eventStream, emitsInOrder(expected));

      counterBloc.add(CounterEvent.increment);
    });

    test('all events are forwarded when forwardEvent is activated', () {
      final expectedEvents = [
        CounterEvent.increment,
        CounterEvent.incremented,
        emitsDone,
      ];
      final counterBloc = CounterBloc(forwardEvents: true);

      expectLater(
        counterBloc.eventStream,
        emitsInOrder(expectedEvents),
      ).then((dynamic _) {
        expect(counterBloc.state, 1);
      });

      expect(counterBloc.isClosed, isFalse);

      counterBloc
        ..add(CounterEvent.increment)
        ..close().then((_) {
          expect(counterBloc.isClosed, isTrue);
        });
    });

    test(
        'throws StateError '
        'when bloc is closed', () async {
      final events = <CounterEvent>[];
      final expectedStateError = isA<StateError>().having(
        (e) => e.message,
        'message',
        'Cannot fire new events after calling close',
      );

      final counterBloc = CounterBloc()..eventStream.listen(events.add);

      await counterBloc.close();

      expect(counterBloc.isClosed, isTrue);
      expect(counterBloc.state, equals(0));
      expect(events, isEmpty);
      expect(
        () => counterBloc.fireEvent(CounterEvent.incremented),
        throwsA(expectedStateError),
      );
      expect(events, isEmpty);
    });
  });
}
