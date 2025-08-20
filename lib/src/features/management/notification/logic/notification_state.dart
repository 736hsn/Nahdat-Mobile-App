import 'package:equatable/equatable.dart';
import '../models/notification_model.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<NotificationModel> notifications;
  final String message;

  NotificationSuccess({required this.notifications, required this.message});

  @override
  List<Object?> get props => [notifications, message];
}

class NotificationError extends NotificationState {
  final String error;

  NotificationError({required this.error});

  @override
  List<Object?> get props => [error];
}
