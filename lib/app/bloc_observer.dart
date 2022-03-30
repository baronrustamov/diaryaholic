// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:dairy_app/core/logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  final log = printer();

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log.d('${bloc.runtimeType} - $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.e('${bloc.runtimeType} - $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.i('${bloc.runtimeType} $transition');
  }
}
