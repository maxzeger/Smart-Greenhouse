import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/resources/api-repository.dart';

import 'actions-event.dart';
import 'actions-state.dart';

class ActionsBloc extends Bloc<ActionsEvent, ActionsState> {
  ActionsBloc() : super(ActionsInitial()) {
    final ApiRepository _apiRepository = ApiRepository();
    on<GetActionsList>((event, emit) async {
      emit(ActionsLoading());
      final actions = await _apiRepository.fetchActions();
      emit(ActionsLoaded(actions));
    });
  }
}
