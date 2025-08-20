import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisor/src/core/api/dio_consumer.dart';
import 'package:supervisor/src/core/api/endpoints.dart';
import 'package:supervisor/src/core/common/models/result.dart';
import 'package:supervisor/src/core/services/notifications_service.dart';
import 'package:supervisor/src/features/voter/models/voter_model.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final DioConsumer _dioConsumer = DioConsumer();

  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile() async {
    try {
      emit(FetchProfileLoading());

      final Result<Response> result = await _dioConsumer.get(
        endpoint: EndPoints.profile,
      );
      if (result.isSuccess) {
        final profileJson = result.data?.data;
        if (profileJson == null) {
          emit(FetchProfileError("Profile not found"));
          return;
        }
        final profile = VoterModel.fromJson(profileJson);
        log('Profile fetched, user name : ${profile.fullName}');

        // Set OneSignal external user ID with delay to ensure initialization
        _setOneSignalExternalUserId(profile.id.toString());

        emit(
          FetchProfileSuccess(
            message: result.data?.data?['message'] ?? 'Profile fetched',
            profile: profile,
            selectedImage: null,
          ),
        );
      } else {
        emit(FetchProfileError(result.error ?? 'Failed to fetch profile'));
        log('Failed to fetch profile : ${result.error}' ?? '');
      }
    } catch (e) {
      emit(FetchProfileError(e.toString()));
      log('Failed to fetch profile : ${e.toString()}' ?? '');
    }
  }

  Future<void> _setOneSignalExternalUserId(String userId) async {
    try {
      // Add small delay to ensure OneSignal is fully initialized
      await Future.delayed(const Duration(milliseconds: 1000));

      // Ensure user is subscribed first (required for external ID to sync)
      log(
        'OneSignal: Ensuring user is subscribed before setting external ID...',
      );
      final isSubscribed = await NotificationsService.ensureUserSubscribed();

      if (!isSubscribed) {
        log(
          'OneSignal: User is not subscribed. External ID will not appear in dashboard.',
        );
        log('OneSignal: Please grant notification permissions when prompted.');
        return;
      }

      if (NotificationsService.isInitialized) {
        await NotificationsService.setExternalUserId(userId);
        log('OneSignal external user ID set successfully for user: $userId');
      } else {
        log('OneSignal not initialized, waiting and retrying...');
        // Wait a bit more and try again
        await Future.delayed(const Duration(milliseconds: 2000));
        await NotificationsService.setExternalUserId(userId);
        log(
          'OneSignal external user ID set successfully for user: $userId (after retry)',
        );
      }

      // Test to verify external user ID is set correctly
      await Future.delayed(const Duration(milliseconds: 500));
      await NotificationsService.testExternalUserId();
    } catch (e) {
      log('Failed to set OneSignal external user ID: $e');
    }
  }

  void selectImage(XFile image) {
    if (state is FetchProfileSuccess) {
      final currentState = state as FetchProfileSuccess;
      emit(currentState.copyWith(selectedImage: image));
    }
  }

  void clearSelectedImage() {
    if (state is FetchProfileSuccess) {
      final currentState = state as FetchProfileSuccess;
      emit(currentState.copyWith(selectedImage: null));
    }
  }
}
