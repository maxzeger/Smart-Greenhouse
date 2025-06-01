import 'package:equatable/equatable.dart';

abstract class TshEvent extends Equatable {
  const TshEvent();

  @override
  List<Object> get props => [];
}

class GetTshObject extends TshEvent {}
