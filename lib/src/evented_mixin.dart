import 'dart:async';

import 'package:evented_bloc/evented_bloc.dart';

import 'package:meta/meta.dart';

/// An object that provides access to a stream of events over time.
abstract class EventStreamable<Event extends Object?> {
  /// The current [Stream] of events.
  Stream<Event> get eventStream;
}

/// A mixin which enables events to be fired from the [BlocBase] instance
/// for [Bloc] and [Cubit] classes, through a new internal
/// stream of events.
///
mixin EventedMixin<Event, State> on BlocBase<State>
    implements EventStreamable<Event> {
  late final StreamController<Event> _eventController =
      StreamController<Event>.broadcast();

  /// The current [Stream] of events.
  @override
  Stream<Event> get eventStream => _eventController.stream;

  // Get `EventedBlocObserver` if any
  EventedBlocObserver? get _eventedBlocObserver {
    final observer = Bloc.observer;
    if (observer is EventedBlocObserver) {
      return observer;
    }
    return null;
  }

  /// Fires the provided [event].
  ///
  /// * Throws a [StateError] if the bloc is closed.
  @protected
  @visibleForTesting
  void fireEvent(Event event) {
    try {
      if (isClosed) {
        throw StateError('Cannot fire new events after calling close');
      }
      onFireEvent(event);
      _eventController.add(event);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      rethrow;
    }
  }

  /// Closes the instance.
  /// This method should be called when the instance is no longer needed.
  /// Once [close] is called, the instance can no longer be used.
  @mustCallSuper
  @override
  Future<void> close() async {
    await super.close();
    await _eventController.close();
  }

  /// Called whenever an [event] is fired from the [EventedBloc].
  /// A great spot to add logging/analytics at the individual [EventedBloc]
  /// level.
  ///
  /// **Note: `super.onFireEvent` should always be called first.**
  /// ```dart
  /// @override
  /// void onFireEvent(Event event) {
  ///   // Always call super.onFireEvent with the current event
  ///   super.onFireEvent(event);
  ///
  ///   // Custom onFireEvent logic goes here
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// * [EventedBlocObserver.onFireEvent] for observing events globally.
  ///
  @protected
  @mustCallSuper
  void onFireEvent(Event event) {
    // ignore: invalid_use_of_protected_member
    _eventedBlocObserver?.onFireEvent(this, event);
  }
}
