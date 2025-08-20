import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/api/dio_consumer.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/common/models/result.dart';
import '../../management/profile/logic/profile/profile_cubit.dart';
import '../../management/profile/logic/profile/profile_state.dart';
import '../models/statistics_model.dart';
import 'home_state.dart';

import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final DioConsumer _dioConsumer = DioConsumer();
  final ProfileCubit _profileCubit;

  HomeCubit(this._profileCubit) : super(HomeInitial());

  Future<void> loadStatistics() async {
    try {
      emit(HomeLoading());

      // Ensure profile is loaded first
      await _ensureProfileLoaded();

      // Load statistics
      final Result<Response> result = await _dioConsumer.get(
        endpoint: EndPoints.statistics,
      );

      if (result.isSuccess) {
        final Map<String, dynamic> responseData = result.data?.data;
        final StatisticsModel statistics = StatisticsModel.fromJson(
          responseData,
        );

        // Calculate distance to polling center
        final distanceInfo = await _calculateDistanceToPollingCenter();

        emit(
          HomeLoaded(
            statistics: statistics,
            distanceToPollingCenter: distanceInfo['distance'],
            isInsidePollingCenter: distanceInfo['isInside'],
            locationMessage: distanceInfo['message'],
          ),
        );
      } else {
        emit(HomeError(error: result.error ?? 'فشل في جلب الإحصائيات'));
      }
    } catch (e) {
      emit(HomeError(error: 'حدث خطأ: ${e.toString()}'));
    }
  }

  Future<void> _ensureProfileLoaded() async {
    final profileState = _profileCubit.state;

    // If profile is not loaded yet, try to load it
    if (profileState is! FetchProfileSuccess) {
      // If it's not already loading, start loading
      if (profileState is! FetchProfileLoading) {
        _profileCubit.fetchProfile();
      }

      // Wait a bit for profile to load
      await Future.delayed(const Duration(milliseconds: 500));

      // Check again after delay
      final newProfileState = _profileCubit.state;
      if (newProfileState is! FetchProfileSuccess) {
        // If still not loaded, wait a bit more
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  Future<Map<String, dynamic>> _calculateDistanceToPollingCenter() async {
    try {
      // Get profile state to access polling center coordinates
      final profileState = _profileCubit.state;
      if (profileState is! FetchProfileSuccess) {
        return {
          'distance': null,
          'isInside': false,
          'message': 'لم يتم جلب معلومات البروفايل',
        };
      }

      final pollingCenter = profileState.profile.pollingCenter;

      // Check if polling center has coordinates
      if (pollingCenter.lat.isEmpty || pollingCenter.lng.isEmpty) {
        return {
          'distance': null,
          'isInside': false,
          'message': 'إحداثيات مركز التصويت غير متوفرة',
        };
      }

      // Get current location
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        return {
          'distance': null,
          'isInside': false,
          'message': 'صلاحية الموقع غير مُفعلة',
        };
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Parse polling center coordinates
      final double pollingCenterLat = double.parse(pollingCenter.lat);
      final double pollingCenterLng = double.parse(pollingCenter.lng);

      // Calculate distance
      final double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        pollingCenterLat,
        pollingCenterLng,
      );

      // Check if inside polling center (within 50 meters)
      const double allowedDistanceInMeters = 50.0;
      final bool isInsidePollingCenter =
          distanceInMeters <= allowedDistanceInMeters;

      String locationMessage;
      if (isInsidePollingCenter) {
        locationMessage = 'أنت داخل مركز التصويت';
      } else {
        final int distanceRounded = distanceInMeters.round();
        locationMessage = 'أنت تبعد عن مركز التصويت بـ $distanceRounded متر';
      }

      return {
        'distance': distanceInMeters,
        'isInside': isInsidePollingCenter,
        'message': locationMessage,
      };
    } catch (e) {
      print('Error calculating distance: $e');
      return {
        'distance': null,
        'isInside': false,
        'message': 'خطأ في حساب المسافة',
      };
    }
  }

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> refreshStatistics() async {
    await loadStatistics();
  }

  void dispose() {}
}
