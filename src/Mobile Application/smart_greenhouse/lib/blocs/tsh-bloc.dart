import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/blocs/tsh-event.dart';
import 'package:smart_greenhouse/blocs/tsh-state.dart';
import 'package:smart_greenhouse/resources/api-repository.dart';

class TshBloc extends Bloc<TshEvent, TshState> {
  TshBloc() : super(TshInitial()) {
    final ApiRepository _apiRepository = ApiRepository();
    on<GetTshObject>((event, emit) async {
      emit(TshLoading());
      final tsh = await _apiRepository.fetchTsh();
      emit(TshLoaded(tsh));
    });
  }
}
