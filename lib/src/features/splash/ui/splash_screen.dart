import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:supervisor/src/core/common/widgets/theme_aware_logo.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/core/services/auth_service.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supervisor/src/features/main/logic/preload.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late final ConnectivityService _connectivityService;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();

    // Check auth status and navigate accordingly after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (isAuthenticated) {
        // User is logged in, go to main screen
        context.go('/main');
      } else {
        // User is not logged in, go to login screen
        // context.go('/main');
        context.go('/login');
      }
    });
  }

  void _checkAuthAndNavigate() {
    final authService = getIt<AuthService>();
    isAuthenticated = authService.isAuthenticated;

    if (isAuthenticated) {
      _handleStartUp();

      // User is logged in, go to main screen
      context.go('/main');
    } else {
      // User is not logged in, go to login screen
      // context.go('/login');
    }
  }

  // void _checkConnectivity() async {
  //   final isConnected = await _connectivityService.isConnected;
  //   if (mounted) {
  //     setState(() {
  //       _isConnected = isConnected;
  //     });
  //   }
  // }

  Future<void> _handleStartUp() async {
    if (mounted) {
      PreloadService().preloadData(context);
      // await context.read<CategoriesCubit>().fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 20.h),
                FadeInDownBig(
                  duration: const Duration(milliseconds: 2000),
                  delay: const Duration(milliseconds: 100),

                  child: ThemeAwareLogo(
                    height: 150,
                    type: 'svg',
                    borderRadius: 10,
                    fit: BoxFit.contain,
                  ),
                ),

                // SizedBox(height: 2.h),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 1.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 1.h),

                TextCustom(
                  text: 'جميع الحقوق محفوظة',
                  fontSize: 6,

                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
                TextCustom(
                  text: '© 2025 لشركة نهضة العراق',
                  // color: Theme.of(context).colorScheme.secondary,
                  fontSize: 4,
                  isSubTitle: true,

                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
                TextCustom(
                  text: 'الاصدار 1.0.0',
                  // color: Theme.of(context).colorScheme.secondary,
                  fontSize: 3,
                  isSubTitle: true,

                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
