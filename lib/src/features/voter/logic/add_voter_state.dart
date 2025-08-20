part of 'add_voter_cubit.dart';

@immutable
sealed class AddVoterState {}

final class AddVoterInitial extends AddVoterState {}

final class PollingCentersLoading extends AddVoterState {}

final class PollingCentersLoaded extends AddVoterState {
  final List<PollingCenterModel> pollingCenters;

  PollingCentersLoaded({required this.pollingCenters});
}

final class PollingCentersError extends AddVoterState {
  final String error;

  PollingCentersError({required this.error});
}

final class AddVoterLoading extends AddVoterState {
  final List<PollingCenterModel> pollingCenters;

  AddVoterLoading({required this.pollingCenters});
}

final class AddVoterSuccess extends AddVoterState {
  final VoterModel voter;

  AddVoterSuccess({required this.voter});
}

final class AddVoterError extends AddVoterState {
  final String error;
  final List<PollingCenterModel> pollingCenters;

  AddVoterError({required this.error, required this.pollingCenters});
}
