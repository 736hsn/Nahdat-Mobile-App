import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';

@singleton
class ConnectivityService {
  final InternetConnectionChecker _connectionChecker;

  // Stream controller for connectivity status
  final _connectivityController = StreamController<bool>.broadcast();

  // Public stream of connectivity status
  Stream<bool> get connectivityStream => _connectivityController.stream;

  ConnectivityService(this._connectionChecker) {
    // Listen to connectivity changes
    _connectionChecker.onStatusChange.listen((status) {
      _connectivityController.add(status == InternetConnectionStatus.connected);
    });
  }

  // Check if currently connected
  Future<bool> get isConnected => _connectionChecker.hasConnection;

  // Dispose resources
  void dispose() {
    _connectivityController.close();
  }
}
