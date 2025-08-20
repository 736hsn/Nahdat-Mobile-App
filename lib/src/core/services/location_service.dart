import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../api/dio_consumer.dart';
import '../api/endpoints.dart';
import '../common/models/result.dart';

@singleton
class LocationService {
  final DioConsumer _dioConsumer;
  Timer? _locationTimer;
  bool _isTracking = false;

  LocationService(this._dioConsumer);

  /// Start location tracking every 10 seconds
  Future<void> startLocationTracking() async {
    if (_isTracking) {
      log('Location tracking is already active');
      return;
    }

    // Check location permission
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      log('Location permission denied');
      return;
    }

    _isTracking = true;
    log('Starting location tracking...');

    // Get initial location
    await _getCurrentLocationAndUpdate();

    // Start periodic updates every 10 seconds
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _getCurrentLocationAndUpdate();
    });
  }

  /// Stop location tracking
  void stopLocationTracking() {
    if (_locationTimer != null) {
      _locationTimer!.cancel();
      _locationTimer = null;
    }
    _isTracking = false;
    log('Location tracking stopped');
  }

  /// Check if location tracking is active
  bool get isTracking => _isTracking;

  /// Get current location and send to API
  Future<void> _getCurrentLocationAndUpdate() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final double lat = position.latitude;
      final double lng = position.longitude;

      // Log the latitude and longitude
      log('Current Location - Lat: $lat, Lng: $lng');
      print('Current Location - Lat: $lat, Lng: $lng');

      // Send location to API
      await _sendLocationToAPI(lat, lng);
    } catch (e) {
      log('Error getting location: $e');
    }
  }

  /// Send location data to API
  Future<void> _sendLocationToAPI(double lat, double lng) async {
    try {
      final Result result = await _dioConsumer.post(
        endpoint: EndPoints.locationUpdate,
        body: {'lat': lat.toString(), 'lng': lng.toString(), '_method': 'PUT'},
      );

      if (result.isSuccess) {
        log('Location sent successfully to API');
      } else {
        log('Failed to send location to API: ${result.error}');
      }
    } catch (e) {
      log('Error sending location to API: $e');
    }
  }

  /// Check and request location permissions
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return false;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied');
      return false;
    }

    return true;
  }

  /// Dispose resources
  void dispose() {
    stopLocationTracking();
  }
}
