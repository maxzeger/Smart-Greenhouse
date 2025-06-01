import 'package:equatable/equatable.dart';
import 'package:smart_greenhouse/models/measurements_model.dart';

abstract class MeasurementsState extends Equatable {
  const MeasurementsState();

  @override
  List<Object?> get props => [];
}

class MeasurementsInitial extends MeasurementsState {}

class MeasurementsLoading extends MeasurementsState {}

class MeasurementsLoaded extends MeasurementsState {
  final MeasurementsModel measurementsModel;

  const MeasurementsLoaded(this.measurementsModel);
}
