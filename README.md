<p align="center">
  <img src="https://github.com/jovazcode/evented_bloc/raw/main/screenshots/logo.png" height="300" alt="Evented Bloc">
</p>

# Evented Bloc

[![build][build_badge]][build_link]
[![coverage][coverage_badge]][build_link]
[![pub package][pub_badge]][pub_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

[build_link]: https://github.com/jovazcode/evented_bloc/actions/workflows/main.yaml
[pub_link]: https://pub.dev/packages/evented_bloc
[build_badge]: https://github.com/jovazcode/evented_bloc/actions/workflows/main.yaml/badge.svg
[coverage_badge]: https://github.com/jovazcode/evented_bloc/raw/main/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[pub_badge]: https://img.shields.io/pub/v/evented_bloc.svg
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

An extension to the bloc state management library which adds support for firing outgoing events from blocs to external listeners.

This package is built to work with:

- [flutter_evented_bloc](https://pub.dev/packages/flutter_evented_bloc)
- [bloc_test](https://pub.dev/packages/bloc_test)

## Quick Start 🚀

```dart
// The event triggered by my BLoC component.
@immutable
class CounterEvent {
  const CounterEvent.incremented() : message = 'Incremented';
  const CounterEvent.decremented() : message = 'Decremented';

  final String message;
}

// Extend `EventedCubit` instead of `Cubit`, or extend standard `Cubit`
// with `EventedMixin<Event, State>`.
// The package also exports: `EventedBloc`
class CounterCubit extends EventedCubit<CounterEvent, int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
    // Fire 'IncrementedEvent' through the event stream
    fireEvent(const CounterEvent.incremented());
  }

  void decrement() {
    emit(state - 1);
    // Fire 'DecrementedEvent' through the event stream
    fireEvent(const CounterEvent.decremented());
  }
}

void main() async {
  // Create an instance of the cubit.
  final cubit = CounterCubit();

  // Subscribe the event stream channel.
  final subscription = cubit.eventStream.listen((event) {
    print(event); // 'Incremented'!!
  });

  // Increment
  cubit.increment();
  await Future.delayed(Duration.zero);

  // Dispose
  await subscription.cancel();
  await cubit.close();
}
```
