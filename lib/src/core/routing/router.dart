import 'package:supervisor/src/core/common/models/news_model.dart';
import 'package:supervisor/src/features/auth/login/ui/login_with_phone_number_screen.dart';
import 'package:supervisor/src/features/auth/login/ui/verify_otp_code_screen.dart';
import 'package:supervisor/src/features/auth/register/ui/register_screen.dart';
import 'package:supervisor/src/features/main/ui/main_screen.dart';
import 'package:supervisor/src/features/management/about_us/ui/about_us_screem.dart';
import 'package:supervisor/src/features/management/contact_us/ui/contact_us.dart';
import 'package:supervisor/src/features/management/privacy/ui/faq_screen.dart';
import 'package:supervisor/src/features/management/privacy/ui/privacy_policy_screen.dart';
import 'package:supervisor/src/features/management/profile/ui/profile_information_screen.dart';
import 'package:supervisor/src/features/management/settings/ui/settings_screen.dart';
import 'package:supervisor/src/features/management/polling_centers/ui/polling_centers_screen.dart';
import 'package:supervisor/src/features/strip/ui/strip_screen.dart';
import 'package:supervisor/src/features/strip/ui/add_strip_screen.dart';
import 'package:supervisor/src/features/strip/models/strip_model.dart';
import 'package:supervisor/src/features/strip/logic/strip/strip_cubit.dart';
import 'package:supervisor/src/features/splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:supervisor/src/features/management/polling_centers/logic/polling_centers_cubit.dart';
import 'package:supervisor/src/features/auth/confirm_entry/ui/confirm_entry_screen.dart';
import 'package:supervisor/src/features/auth/confirm_entry/logic/confirm_entry_cubit.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/main',
      name: 'main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginWithPhoneNumberScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      name: 'verify_otp',
      builder: (context, state) {
        final phoneNumber = state.extra as String? ?? '';
        return VerifyOtpCodeScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // GoRoute(
    //   path: '/category',
    //   name: 'category',
    //   builder: (context, state) => const CategoryScreen(),
    // ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // Strip routes
    GoRoute(
      path: '/strips',
      name: 'strips',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<StripCubit>(),
        child: const StripScreen(),
      ),
    ),
    GoRoute(
      path: '/add-strip',
      name: 'add_strip',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<StripCubit>()),
          BlocProvider(create: (context) => getIt<PollingCentersCubit>()),
        ],
        child: AddStripScreen(stripToEdit: state.extra as StripModel?),
      ),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<StripCubit>(),
        child: const StripScreen(),
      ),
    ),

    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileInformationScreen(),
    ),

    GoRoute(
      path: '/polling-centers',
      name: 'polling_centers',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<PollingCentersCubit>(),
        child: const PollingCentersScreen(),
      ),
    ),

    GoRoute(
      path: '/about-us',
      name: 'about_us',
      builder: (context, state) => const AboutUsScreen(),
    ),

    GoRoute(
      path: '/contact-us',
      name: 'contact_us',
      builder: (context, state) => const ContactUsScreen(),
    ),

    GoRoute(
      path: '/privacy-policy',
      name: 'privacy_policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/faq',
      name: 'faq',
      builder: (context, state) => const FaqScreen(),
    ),
    GoRoute(
      path: '/confirm-entry',
      name: 'confirm_entry',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<ConfirmEntryCubit>(),
        child: const ConfirmEntryScreen(),
      ),
    ),
  ],
);
