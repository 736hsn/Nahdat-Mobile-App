import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:supervisor/src/core/api/dio_consumer.dart';
import 'package:supervisor/src/core/api/endpoints.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_cubit.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_state.dart';
import 'confirm_entry_state.dart';
import '../ui/face_camera_screen.dart';

@injectable
class ConfirmEntryCubit extends Cubit<ConfirmEntryState> {
  final DioConsumer _dioConsumer;
  final ProfileCubit _profileCubit;

  ConfirmEntryCubit(this._dioConsumer, this._profileCubit)
    : super(ConfirmEntryInitial());

  // Allowed distance constant - same as HomeScreen
  static const double allowedDistanceInMeters = 50.0;

  String? _capturedImagePath;
  double? _currentLat;
  double? _currentLng;
  bool _isInsidePollingCenter = false;

  String? get capturedImagePath => _capturedImagePath;
  double? get currentLat => _currentLat;
  double? get currentLng => _currentLng;
  bool get isInsidePollingCenter => _isInsidePollingCenter;

  /// Check current location and validate distance from polling center
  Future<void> checkCurrentLocation() async {
    try {
      emit(ConfirmEntryLocationChecking());

      // Ensure profile is loaded first - same as HomeScreen
      await _ensureProfileLoaded();

      // Calculate distance to polling center using profile data
      final distanceInfo = await _calculateDistanceToPollingCenter();

      if (distanceInfo['distance'] != null) {
        _currentLat = distanceInfo['currentLat'];
        _currentLng = distanceInfo['currentLng'];
        _isInsidePollingCenter = distanceInfo['isInside'];

        emit(
          ConfirmEntryLocationSuccess(
            isInsidePollingCenter: _isInsidePollingCenter,
            distanceInMeters: distanceInfo['distance'],
            locationMessage: distanceInfo['message'],
          ),
        );
      } else {
        emit(ConfirmEntryLocationError(error: distanceInfo['message']));
      }
    } catch (e) {
      emit(ConfirmEntryLocationError(error: 'خطأ في تحديد الموقع: $e'));
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
          'currentLat': null,
          'currentLng': null,
        };
      }

      final pollingCenter = profileState.profile.pollingCenter;

      // Check if polling center has coordinates
      if (pollingCenter.lat.isEmpty || pollingCenter.lng.isEmpty) {
        return {
          'distance': null,
          'isInside': false,
          'message': 'إحداثيات مركز التصويت غير متوفرة',
          'currentLat': null,
          'currentLng': null,
        };
      }

      // Get current location
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        return {
          'distance': null,
          'isInside': false,
          'message': 'صلاحية الموقع غير مُفعلة',
          'currentLat': null,
          'currentLng': null,
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

      // Check if inside polling center (within 50 meters) - same as HomeScreen
      final bool isInsidePollingCenter =
          distanceInMeters <= allowedDistanceInMeters;

      String locationMessage;
      if (isInsidePollingCenter) {
        locationMessage = 'أنت داخل مركز التصويت - يمكنك تأكيد الدخول';
      } else {
        final int distanceRounded = distanceInMeters.round();
        locationMessage = 'أنت خارج مركز التصويت - تبعد $distanceRounded متر';
      }

      return {
        'distance': distanceInMeters,
        'isInside': isInsidePollingCenter,
        'message': locationMessage,
        'currentLat': position.latitude,
        'currentLng': position.longitude,
      };
    } catch (e) {
      print('Error calculating distance: $e');
      return {
        'distance': null,
        'isInside': false,
        'message': 'خطأ في حساب المسافة',
        'currentLat': null,
        'currentLng': null,
      };
    }
  }

  /// Open face camera to capture image
  Future<void> openFaceCamera(BuildContext context) async {
    if (!_isInsidePollingCenter) {
      emit(
        const ConfirmEntryError(
          error: 'يجب أن تكون داخل مركز التصويت لتأكيد الدخول',
        ),
      );
      return;
    }

    try {
      emit(ConfirmEntryCameraOpening());

      // Check camera permissions first
      final hasPermission = await _checkCameraPermissions();
      if (!hasPermission) {
        emit(
          const ConfirmEntryCameraError(
            error: 'يرجى السماح بالوصول إلى الكاميرا من إعدادات التطبيق',
          ),
        );
        return;
      }

      // Add delay to ensure camera initialization
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to face camera screen
      final result = await Navigator.push<File?>(
        context,
        MaterialPageRoute(
          builder: (context) => const FaceCameraScreen(),
          fullscreenDialog: true,
        ),
      );

      if (result != null) {
        _capturedImagePath = result.path;
        emit(ConfirmEntryCameraSuccess(imagePath: _capturedImagePath!));
      } else {
        emit(const ConfirmEntryCameraError(error: 'لم يتم التقاط صورة'));
      }
    } catch (e) {
      String errorMessage = 'خطأ في فتح الكاميرا';
      if (e.toString().contains('permission')) {
        errorMessage = 'يرجى السماح بالوصول إلى الكاميرا من إعدادات التطبيق';
      } else if (e.toString().contains('camera')) {
        errorMessage = 'خطأ في الكاميرا - يرجى المحاولة مرة أخرى';
      }
      emit(ConfirmEntryCameraError(error: errorMessage));
    }
  }

  /// Check camera permissions
  Future<bool> _checkCameraPermissions() async {
    try {
      final cameraStatus = await Permission.camera.status;

      if (cameraStatus.isGranted) {
        return true;
      } else if (cameraStatus.isDenied) {
        final result = await Permission.camera.request();
        return result.isGranted;
      } else if (cameraStatus.isPermanentlyDenied) {
        // Open app settings if permanently denied
        await openAppSettings();
        return false;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Submit entry confirmation
  Future<void> submitEntryConfirmation() async {
    if (!_isInsidePollingCenter) {
      emit(const ConfirmEntryError(error: 'يجب أن تكون داخل مركز التصويت'));
      return;
    }

    if (_capturedImagePath == null) {
      emit(const ConfirmEntryError(error: 'يجب التقاط صورة أولاً'));
      return;
    }

    if (_currentLat == null || _currentLng == null) {
      emit(const ConfirmEntryError(error: 'يجب تحديد الموقع أولاً'));
      return;
    }

    try {
      emit(ConfirmEntrySubmitting());

      // Create multipart file from the captured image
      final imageFile = await MultipartFile.fromFile(
        _capturedImagePath!,
        filename: 'face_image.jpg',
      );

      // Prepare API call with correct parameters
      final result = await _dioConsumer.multipartPost(
        endpoint: EndPoints.confirmEntry,
        fields: {
          'lat': _currentLat!.toString(),
          'lng': _currentLng!.toString(),
        },
        fileSections: {
          'image': [imageFile],
        },
      );

      if (result.isSuccess) {
        emit(const ConfirmEntrySuccess(message: 'تم تأكيد الدخول بنجاح'));

        // Reset state after successful submission
        _capturedImagePath = null;
        _currentLat = null;
        _currentLng = null;
        _isInsidePollingCenter = false;
      } else {
        emit(ConfirmEntryError(error: result.error ?? 'فشل في تأكيد الدخول'));
      }
    } catch (e) {
      emit(ConfirmEntryError(error: 'خطأ في تأكيد الدخول: $e'));
    }
  }

  /// Check location permissions
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

  /// Reset state
  void resetState() {
    _capturedImagePath = null;
    _currentLat = null;
    _currentLng = null;
    _isInsidePollingCenter = false;
    emit(ConfirmEntryInitial());
  }
}
