import '../models/statistics_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final StatisticsModel statistics;
  final double? distanceToPollingCenter;
  final bool? isInsidePollingCenter;
  final String? locationMessage;

  HomeLoaded({
    required this.statistics,
    this.distanceToPollingCenter,
    this.isInsidePollingCenter,
    this.locationMessage,
  });
}

class HomeError extends HomeState {
  final String error;

  HomeError({required this.error});
}
