import 'package:equatable/equatable.dart';

import '../models/actions_model.dart';

abstract class ActionsState extends Equatable {
  const ActionsState();

  @override
  List<Object?> get props => [];
}

class ActionsInitial extends ActionsState {}

class ActionsLoading extends ActionsState {}

class ActionsLoaded extends ActionsState {
  final ActionsModel actionsModel;

  const ActionsLoaded(this.actionsModel);
}
