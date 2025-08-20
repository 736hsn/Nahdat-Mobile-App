import 'package:supervisor/src/core/theme/theme_cubit.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:supervisor/src/features/auth/login/logic/login_cubit.dart';
import 'package:supervisor/src/features/auth/register/logic/register_cubit.dart';
import 'package:supervisor/src/features/home/logic/home_cubit.dart';
import 'package:supervisor/src/features/main/logic/main_cubit.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_cubit.dart';
import 'package:supervisor/src/features/management/notification/logic/notification_cubit.dart';
import 'package:supervisor/src/features/strip/logic/strip/strip_cubit.dart';
import 'package:supervisor/src/features/voter/logic/voter_cubit.dart';
import 'package:supervisor/src/features/voter/logic/add_voter_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> appProviders = [
  // BlocProvider<DioConsumer>(create: (context) => getIt<DioConsumer>()),
  BlocProvider<HomeCubit>(create: (context) => getIt<HomeCubit>()),

  BlocProvider<LoginCubit>(create: (context) => getIt<LoginCubit>()),
  BlocProvider<RegisterCubit>(create: (context) => getIt<RegisterCubit>()),
  BlocProvider<StripCubit>(create: (context) => getIt<StripCubit>()),
  BlocProvider<MainCubit>(create: (context) => getIt<MainCubit>()),
  BlocProvider<ThemeCubit>(create: (context) => getIt<ThemeCubit>()),
  BlocProvider<VoterCubit>(create: (context) => getIt<VoterCubit>()),
  BlocProvider<AddVoterCubit>(create: (context) => getIt<AddVoterCubit>()),
  BlocProvider<ProfileCubit>(create: (context) => getIt<ProfileCubit>()),

  BlocProvider<NotificationCubit>(
    create: (context) => getIt<NotificationCubit>(),
  ),

  // BlocProvider<PriceCubit>(create: (context) => getIt<PriceCubit>()),
];
