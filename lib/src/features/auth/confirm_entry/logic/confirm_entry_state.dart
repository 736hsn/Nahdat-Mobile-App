import 'package:flutter/foundation.dart';

@immutable
abstract class ConfirmEntryState {
  const ConfirmEntryState();
}

class ConfirmEntryInitial extends ConfirmEntryState {}

class ConfirmEntryLoading extends ConfirmEntryState {}

class ConfirmEntryLocationChecking extends ConfirmEntryState {}

class ConfirmEntryLocationSuccess extends ConfirmEntryState {
  final bool isInsidePollingCenter;
  final double distanceInMeters;
  final String locationMessage;

  const ConfirmEntryLocationSuccess({
    required this.isInsidePollingCenter,
    required this.distanceInMeters,
    required this.locationMessage,
  });
}

class ConfirmEntryLocationError extends ConfirmEntryState {
  final String error;

  const ConfirmEntryLocationError({required this.error});
}

class ConfirmEntryCameraOpening extends ConfirmEntryState {}

class ConfirmEntryCameraSuccess extends ConfirmEntryState {
  final String imagePath;

  const ConfirmEntryCameraSuccess({required this.imagePath});
}

class ConfirmEntryCameraError extends ConfirmEntryState {
  final String error;

  const ConfirmEntryCameraError({required this.error});
}

class ConfirmEntrySubmitting extends ConfirmEntryState {}

class ConfirmEntrySuccess extends ConfirmEntryState {
  final String message;

  const ConfirmEntrySuccess({required this.message});
}

class ConfirmEntryError extends ConfirmEntryState {
  final String error;

  const ConfirmEntryError({required this.error});
}
