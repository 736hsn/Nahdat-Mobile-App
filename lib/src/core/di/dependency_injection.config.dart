// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:supervisor/src/core/api/dio_consumer.dart' as _i988;
import 'package:supervisor/src/core/services/auth_service.dart' as _i708;
import 'package:supervisor/src/core/services/connectivity_service.dart'
    as _i683;
import 'package:supervisor/src/core/services/location_service.dart' as _i528;
import 'package:supervisor/src/core/services/notifications_service.dart'
    as _i347;
import 'package:supervisor/src/core/services/voter_service.dart' as _i126;
import 'package:supervisor/src/core/theme/theme_cubit.dart' as _i264;
import 'package:supervisor/src/features/auth/confirm_entry/logic/confirm_entry_cubit.dart'
    as _i699;
import 'package:supervisor/src/features/auth/login/logic/login_cubit.dart'
    as _i693;
import 'package:supervisor/src/features/auth/register/logic/register_cubit.dart'
    as _i464;
import 'package:supervisor/src/features/home/logic/home_cubit.dart' as _i566;
import 'package:supervisor/src/features/main/logic/main_cubit.dart' as _i420;
import 'package:supervisor/src/features/management/notification/logic/notification_cubit.dart'
    as _i469;
import 'package:supervisor/src/features/management/polling_centers/logic/polling_centers_cubit.dart'
    as _i338;
import 'package:supervisor/src/features/management/profile/logic/profile/profile_cubit.dart'
    as _i512;
import 'package:supervisor/src/features/strip/logic/strip/strip_cubit.dart'
    as _i341;
import 'package:supervisor/src/features/voter/logic/add_voter_cubit.dart'
    as _i990;
import 'package:supervisor/src/features/voter/logic/voter_cubit.dart' as _i113;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i264.ThemeCubit>(() => _i264.ThemeCubit());
    gh.factory<_i341.StripCubit>(() => _i341.StripCubit());
    gh.factory<_i464.RegisterCubit>(() => _i464.RegisterCubit());
    gh.factory<_i693.LoginCubit>(() => _i693.LoginCubit());
    gh.factory<_i512.ProfileCubit>(() => _i512.ProfileCubit());
    gh.factory<_i420.MainCubit>(() => _i420.MainCubit());
    gh.factory<_i469.NotificationCubit>(() => _i469.NotificationCubit());
    gh.singleton<_i988.DioConsumer>(() => _i988.DioConsumer());
    gh.singleton<_i347.NotificationsService>(
      () => _i347.NotificationsService(),
    );
    gh.singleton<_i708.AuthService>(() => _i708.AuthService());
    gh.singleton<_i528.LocationService>(
      () => _i528.LocationService(gh<_i988.DioConsumer>()),
    );
    gh.factory<_i126.VoterService>(
      () => _i126.VoterService(gh<_i988.DioConsumer>()),
    );
    gh.factory<_i699.ConfirmEntryCubit>(
      () => _i699.ConfirmEntryCubit(
        gh<_i988.DioConsumer>(),
        gh<_i512.ProfileCubit>(),
      ),
    );
    gh.singleton<_i683.ConnectivityService>(
      () => _i683.ConnectivityService(gh<_i973.InternetConnectionChecker>()),
    );
    gh.factory<_i566.HomeCubit>(
      () => _i566.HomeCubit(gh<_i512.ProfileCubit>()),
    );
    gh.factory<_i338.PollingCentersCubit>(
      () => _i338.PollingCentersCubit(gh<_i126.VoterService>()),
    );
    gh.factory<_i990.AddVoterCubit>(
      () => _i990.AddVoterCubit(gh<_i126.VoterService>()),
    );
    gh.factory<_i113.VoterCubit>(
      () => _i113.VoterCubit(gh<_i126.VoterService>()),
    );
    return this;
  }
}
