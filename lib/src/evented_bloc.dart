import 'package:evented_bloc/evented_bloc.dart';

/// {@template evented_bloc}
/// A specialized [Bloc] which adds support for firing outgoing
/// events from blocs to external listeners.
/// {@endtemplate}
abstract class EventedBloc<Event, State> extends Bloc<Event, State>
    with EventedMixin<Event, State> {
  /// {@macro evented_bloc}
  EventedBloc(
    super.state, {
    this.forwardEvents = false,
  });

  /// Whether the bloc forwards (re-fires) every received events.
  final bool forwardEvents;

  @override
  void onEvent(Event event) {
    super.onEvent(event);
    if (forwardEvents) {
      fireEvent(event);
    }
  }
}
