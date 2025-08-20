part of 'strip_cubit.dart';

sealed class StripState {}

final class StripInitial extends StripState {}

final class StripLoading extends StripState {}

final class StripLoaded extends StripState {
  final List<StripModel> strips;

  StripLoaded({required this.strips});
}

final class StripError extends StripState {
  final String message;

  StripError({required this.message});
}

// Search states
final class StripSearchEmpty extends StripState {}

final class StripSearchLoading extends StripState {}

final class StripSearchSuccess extends StripState {
  final List<SearchResult> results;

  StripSearchSuccess({required this.results});
}

final class StripSearchNoResults extends StripState {}

final class StripSearchError extends StripState {
  final String message;

  StripSearchError({required this.message});
}

// Add Strip states
final class StripAddLoading extends StripState {}

final class StripAddSuccess extends StripState {
  final String message;

  StripAddSuccess({required this.message});
}

final class StripAddError extends StripState {
  final String message;

  StripAddError({required this.message});
}

// Update Strip states
final class StripUpdateLoading extends StripState {}

final class StripUpdateSuccess extends StripState {
  final String message;

  StripUpdateSuccess({required this.message});
}

final class StripUpdateError extends StripState {
  final String message;

  StripUpdateError({required this.message});
}

// Delete Strip states
final class StripDeleteLoading extends StripState {}

final class StripDeleteSuccess extends StripState {
  final String message;

  StripDeleteSuccess({required this.message});
}

final class StripDeleteError extends StripState {
  final String message;

  StripDeleteError({required this.message});
}
