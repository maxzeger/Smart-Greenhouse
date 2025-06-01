import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_greenhouse/resources/api-repository.dart';

import 'measurements-event.dart';
import 'measurements-state.dart';

class MeasurementsBloc extends Bloc<MeasurementsEvent, MeasurementsState> {
  MeasurementsBloc() : super(MeasurementsInitial()) {
    final ApiRepository _apiRepository = ApiRepository();
    on<GetMeasurementsList>((event, emit) async {
      emit(MeasurementsLoading());
      final measurements = await _apiRepository.fetchMeasurements();
      emit(MeasurementsLoaded(measurements));
    });
  }
}
