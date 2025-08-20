import '../../../models/governorate_model.dart';

abstract class GovernoratesState {}

class GovernoratesInitial extends GovernoratesState {}

class FetchGovernoratesLoading extends GovernoratesState {}

class FetchGovernoratesSuccess extends GovernoratesState {
  final String message;
  final List<GovernorateModel> governorates;

  FetchGovernoratesSuccess(this.message, this.governorates);
}

class FetchGovernoratesError extends GovernoratesState {
  final String error;

  FetchGovernoratesError(this.error);
}
