import 'package:equatable/equatable.dart';
import 'package:smart_greenhouse/models/tsh_model.dart';

abstract class TshState extends Equatable {
  const TshState();

  @override
  List<Object?> get props => [];
}

class TshInitial extends TshState {}

class TshLoading extends TshState {}

class TshLoaded extends TshState {
  final TSHModel tshModel;

  const TshLoaded(this.tshModel);
}
