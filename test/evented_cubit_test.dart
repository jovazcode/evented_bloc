import 'package:test/test.dart';

import 'cubits/cubits.dart';

void main() {
  group('CounterCubit', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });

    test('state returns correct value initially', () {
      expect(counterCubit.state, 0);
    });

    test('single Increment event updates state to 1', () {
      final expectedStates = [1, emitsDone];
      final counterCubit = CounterCubit();

      expectLater(
        counterCubit.stream,
        emitsInOrder(expectedStates),
      ).then((dynamic _) {
        expect(counterCubit.state, 1);
      });

      counterCubit
        ..increment()
        ..close();
    });

    test('multiple Increment event updates state to 3', () {
      final expectedStates = [1, 2, 3, emitsDone];
      final counterCubit = CounterCubit();

      expectLater(
        counterCubit.stream,
        emitsInOrder(expectedStates),
      ).then((dynamic _) {
        expect(counterCubit.state, 3);
      });

      counterCubit
        ..increment()
        ..increment()
        ..increment()
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
      final counterCubit = CounterCubit();

      expectLater(
        counterCubit.eventStream,
        emitsInOrder(expectedEvents),
      ).then((dynamic _) {
        expect(counterCubit.state, 0);
      });

      counterCubit
        ..increment()
        ..decrement()
        ..close();
    });

    test('multiple Increment event generates multiple Incremented event', () {
      final expectedEvents = [
        CounterEvent.incremented,
        CounterEvent.incremented,
        CounterEvent.incremented,
        emitsDone,
      ];
      final counterCubit = CounterCubit();

      expectLater(
        counterCubit.eventStream,
        emitsInOrder(expectedEvents),
      ).then((dynamic _) {
        expect(counterCubit.state, 3);
      });

      counterCubit
        ..increment()
        ..increment()
        ..increment()
        ..close();
    });

    test('is a broadcast stream', () {
      final expectedEvents = [
        CounterEvent.incremented,
        CounterEvent.decremented,
        emitsDone,
      ];

      expect(counterCubit.eventStream.isBroadcast, isTrue);
      expectLater(counterCubit.eventStream, emitsInOrder(expectedEvents));
      expectLater(counterCubit.eventStream, emitsInOrder(expectedEvents));

      counterCubit
        ..increment()
        ..decrement()
        ..close();
    });

    test('multiple subscribers receive the latest state', () {
      const expected = <int>[1];

      expectLater(counterCubit.stream, emitsInOrder(expected));
      expectLater(counterCubit.stream, emitsInOrder(expected));
      expectLater(counterCubit.stream, emitsInOrder(expected));

      counterCubit.increment();
    });

    test('multiple subscribers receive the latest event', () {
      const expected = <CounterEvent>[CounterEvent.incremented];

      expectLater(counterCubit.eventStream, emitsInOrder(expected));
      expectLater(counterCubit.eventStream, emitsInOrder(expected));
      expectLater(counterCubit.eventStream, emitsInOrder(expected));

      counterCubit.increment();
    });
  });
}
