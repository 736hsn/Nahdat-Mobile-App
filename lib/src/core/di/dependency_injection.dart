import 'package:supervisor/src/core/di/dependency_injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

SharedPreferences? sharedPreferences;

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async {
  sharedPreferences = await SharedPreferences.getInstance(); //singleton
  getIt.registerSingleton<SharedPreferences>(sharedPreferences!); //singleton

  // Register InternetConnectionChecker
  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );

  // DioConsumer, ConnectivityService and NotificationsService are registered by injectable via @singleton annotation

  await getIt.init(); //injectable
}

// singleton
// injectable
// registerLazySingleton
