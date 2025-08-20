import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:face_camera/face_camera.dart';
import 'package:supervisor/src/core/providers/app_providers.dart';
import 'package:supervisor/src/core/routing/router.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/core/theme/theme.dart';
import 'package:supervisor/src/core/theme/theme_cubit.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:supervisor/src/core/services/notifications_service.dart';

void main() async {
  // onesecnal id 25a983c8-8450-47cc-80db-12fef26be775
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter binding
  await EasyLocalization.ensureInitialized(); // Initialize EasyLocalization
  await configureDependencies(); // Initialize our cubits
  await FaceCamera.initialize(); // Initialize face camera
  await NotificationsService.initializeOneSignal(); // Initialize OneSignal

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'DZ'),
        Locale('fa', 'IR'),
      ],
      path: 'assets/translations',
      saveLocale: true,
      startLocale: Locale('ar', 'DZ'),
      fallbackLocale: const Locale('ar', 'DZ'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        SizeConfig().init(constraints);
        return MultiBlocProvider(
          providers: appProviders,
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                routerConfig: appRouter,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeState.themeMode,
              );
            },
          ),
        );
      },
    );
  }
}
