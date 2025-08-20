part of 'polling_centers_cubit.dart';

@immutable
sealed class PollingCentersState {}

final class PollingCentersInitial extends PollingCentersState {}

final class PollingCentersLoading extends PollingCentersState {}

final class PollingCentersLoaded extends PollingCentersState {
  final List<PollingCenterModel> pollingCenters;

  PollingCentersLoaded({required this.pollingCenters});
}

final class PollingCentersError extends PollingCentersState {
  final String error;

  PollingCentersError({required this.error});
}
