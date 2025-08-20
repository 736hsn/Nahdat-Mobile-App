import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supervisor/src/core/api/dio_consumer.dart';
import 'package:supervisor/src/core/api/endpoints.dart';
import 'package:supervisor/src/core/common/models/result.dart';
import '../models/notification_model.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final DioConsumer _dioConsumer = DioConsumer();

  NotificationCubit() : super(NotificationInitial());

  Future<void> fetchNotifications() async {
    try {
      emit(NotificationLoading());

      final Result<Response> result = await _dioConsumer.get(
        endpoint: EndPoints.notifications,
      );

      if (result.isSuccess) {
        final Map<String, dynamic>? responseData = result.data?.data;
        if (responseData == null) {
          emit(NotificationError(error: "No notifications found"));
          return;
        }

        final List<dynamic> notificationsJson =
            responseData['data'] as List<dynamic>;
        final List<NotificationModel> notifications = notificationsJson
            .map((json) => NotificationModel.fromJson(json))
            .toList();

        log('Notifications fetched, count: ${notifications.length}');

        emit(
          NotificationSuccess(
            notifications: notifications,
            message:
                responseData['message'] ?? 'Notifications fetched successfully',
          ),
        );
      } else {
        emit(
          NotificationError(
            error: result.error ?? 'Failed to fetch notifications',
          ),
        );
        log('Failed to fetch notifications: ${result.error}');
      }
    } catch (e) {
      emit(NotificationError(error: e.toString()));
      log('Failed to fetch notifications: ${e.toString()}');
    }
  }
}
