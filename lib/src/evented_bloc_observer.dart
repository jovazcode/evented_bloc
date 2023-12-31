import 'package:evented_bloc/evented_bloc.dart';
import 'package:meta/meta.dart';

/// {@template bloc_observer}
/// An interface for observing the behavior of [EventedBloc] instances.
/// {@endtemplate}
abstract class EventedBlocObserver extends BlocObserver {
  /// {@macro bloc_observer}
  const EventedBlocObserver();

  /// Called whenever an [event] is `fired` from any [bloc] with the
  /// given [bloc] and [event].
  @protected
  @mustCallSuper
  void onFireEvent(EventedMixin<dynamic, dynamic> bloc, Object? event) {}
}
