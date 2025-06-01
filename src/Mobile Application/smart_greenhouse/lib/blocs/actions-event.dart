import 'package:equatable/equatable.dart';

abstract class ActionsEvent extends Equatable {
  const ActionsEvent();

  @override
  List<Object> get props => [];
}

class GetActionsList extends ActionsEvent {}
