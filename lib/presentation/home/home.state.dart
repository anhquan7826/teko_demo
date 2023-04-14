import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitialState extends HomeState {
  const HomeInitialState();

  @override
  List<Object?> get props => [];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();

  @override
  List<Object?> get props => [];
}

class HomeLoadedState extends HomeState {
  const HomeLoadedState();

  @override
  List<Object?> get props => [];
}

class HomeLoadErrorState extends HomeState {
  const HomeLoadErrorState({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}