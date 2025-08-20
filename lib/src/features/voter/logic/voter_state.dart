part of 'voter_cubit.dart';

@immutable
sealed class VoterState {}

final class VoterInitial extends VoterState {}

final class VoterLoading extends VoterState {}

final class VoterSuccess extends VoterState {
  final List<VoterModel> voters;
  final VoterMeta meta;

  VoterSuccess({required this.voters, required this.meta});
}

final class VoterLoadingMore extends VoterState {
  final List<VoterModel> voters;
  final VoterMeta meta;

  VoterLoadingMore({required this.voters, required this.meta});
}

final class VoterDetailSuccess extends VoterState {
  final VoterModel voter;

  VoterDetailSuccess({required this.voter});
}

final class VoterUpdateSuccess extends VoterState {
  final VoterModel voter;

  VoterUpdateSuccess({required this.voter});
}

final class VoterVotingSuccess extends VoterState {
  final List<VoterModel> voters;
  final VoterMeta meta;
  final int votedVoterId;

  VoterVotingSuccess({
    required this.voters,
    required this.meta,
    required this.votedVoterId,
  });
}

final class VoterVotingError extends VoterState {
  final String error;
  final int voterId;

  VoterVotingError({required this.error, required this.voterId});
}

final class VoterError extends VoterState {
  final String error;

  VoterError({required this.error});
}
