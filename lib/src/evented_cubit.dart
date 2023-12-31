import 'package:evented_bloc/evented_bloc.dart';

/// {@template evented_cubit}
/// A specialized [Cubit] which adds support for firing outgoing
/// events from blocs to external listeners.
/// {@endtemplate}
abstract class EventedCubit<Event, State> extends Cubit<State>
    with EventedMixin<Event, State> {
  /// {@macro evented_cubit}
  EventedCubit(super.state);
}
