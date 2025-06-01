import 'package:equatable/equatable.dart';

abstract class MeasurementsEvent extends Equatable {
  const MeasurementsEvent();

  @override
  List<Object> get props => [];
}

class GetMeasurementsList extends MeasurementsEvent {}
