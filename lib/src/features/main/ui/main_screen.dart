import 'package:supervisor/src/core/common/widgets/shimmer_container.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/theme_aware_logo.dart';
import 'package:supervisor/src/core/services/connectivity_service.dart';
import 'package:supervisor/src/core/services/location_service.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/features/home/ui/home_scareen.dart';
import 'package:supervisor/src/features/management/notification/ui/notifications_screen.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_cubit.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_state.dart';
import 'package:supervisor/src/features/management/settings/ui/settings_screen.dart';
import 'package:supervisor/src/features/strip/ui/strip_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/features/voter/ui/voter_scareen.dart';

import '../logic/main_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  // static bool _dataLoadedFromSplash = false;

  // static void setDataLoaded() {
  //   _dataLoadedFromSplash = true;
  // }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final ConnectivityService _connectivityService;
  late final LocationService _locationService;
  bool _isConnected = true;
  bool _isInitialized = true;

  @override
  void initState() {
    super.initState();

    // Initialize location service
    _locationService = getIt<LocationService>();

    // Fetch profile data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().fetchProfile();

      // Start location tracking
      _locationService.startLocationTracking();
    });

    // if (!MainScreen._dataLoadedFromSplash) {
    //   _handleStartUp();
    // } else {
    //   MainScreen._dataLoadedFromSplash = false;
    // }

    // _connectivityService = getIt<ConnectivityService>();
    // _initializeConnectivity();
  }

  @override
  void dispose() {
    // Stop location tracking when screen is disposed
    _locationService.stopLocationTracking();
    super.dispose();
  }

  // final preloadService = PreloadService();

  // Future<void> _initializeConnectivity() async {
  //   final isConnected = await _connectivityService.isConnected;

  //   if (mounted) {
  //     setState(() {
  //       _isConnected = isConnected;
  //       _isInitialized = true;
  //     });

  //     _listenToConnectivityChanges();
  //   }
  // }

  // void _listenToConnectivityChanges() {
  //   _connectivityService.connectivityStream.listen((isConnected) {
  //     if (mounted) {
  //       setState(() {
  //         _isConnected = isConnected;
  //       });

  //       if (isConnected && !_isInitialized) {
  //         _handleStartUp();
  //       }
  //     }
  //   });
  // }

  Future<void> _handleStartUp() async {
    if (mounted) {
      // context.read<NewsSliderCubit>().fetchNewsSlider();
      // context.read<CategoriesCubit>().fetchCategories();
      // Uncomment this if you want to fetch home data
      // context.read<HomeCubit>().fetchHomeData();
    }
  }

  void _checkConnectivity() async {
    final isConnected = await _connectivityService.isConnected;
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });

      if (isConnected) {
        _handleStartUp();
      }
    }
  }

  Future<bool?> showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextCustom(
            // areYouSureYouWantToLeaveTheApp
            text: "هل انت متأكد من اغلاق التطبيق؟",
            fontWeight: FontWeight.w600,
            maxLines: 3,
            fontSize: 6,
            height: 1.5,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              child: TextCustom(
                text: "لا",
                fontWeight: FontWeight.w600,
                fontSize: 5.5,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: TextCustom(
                text: "نعم",
                color: Colors.red,
                fontWeight: FontWeight.w700,
                fontSize: 5.5,
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        await showBackDialog(context);
      },
      child: _buildMainScreen(),
    );
  }

  Widget _buildMainScreen() {
    return BlocProvider(
      create: (context) => getIt<MainCubit>(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withOpacity(0.95),
                ],
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is FetchProfileSuccess) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // صورة المستخدم
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      state.profile.imagePath != null &&
                                          state.profile.imagePath!.isNotEmpty
                                      ? Image.network(
                                          state.profile.imagePath!,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.person,
                                                  size: 30,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                );
                                              },
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(
                                                            Theme.of(
                                                              context,
                                                            ).primaryColor,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              },
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // معلومات المستخدم
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Icon(
                                        //   Iconsax.emoji_happy,
                                        //   size: 16,
                                        //   color: Theme.of(context).primaryColor,
                                        // ),
                                        const SizedBox(width: 4),
                                        TextCustom(
                                          text: "أهلاً بك",
                                          fontSize: 5.5,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    TextCustom(
                                      text: state.profile.fullName,
                                      fontSize: 6,
                                      height: 1.3,
                                      fontWeight: FontWeight.w600,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 1),

                                    TextCustom(
                                      text: state
                                          .profile
                                          .pollingCenter
                                          .actualName,
                                      fontSize: 4,
                                      isSubTitle: true,
                                      fontWeight: FontWeight.w500,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is FetchProfileLoading) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // صورة المستخدم أثناء التحميل
                              ShimmerContainerCustom(
                                height: 50,
                                width: 50,
                                borderRadius: 25,
                              ),
                              const SizedBox(width: 12),
                              // معلومات المستخدم أثناء التحميل
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerContainerCustom(
                                      height: 1.5,
                                      width: 25,
                                      borderRadius: 3.5,
                                    ),
                                    SizedBox(height: 1.h),
                                    ShimmerContainerCustom(
                                      height: 2,
                                      width: 35,
                                      borderRadius: 3.5,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    ShimmerContainerCustom(
                                      height: 1.2,
                                      width: 40,
                                      borderRadius: 3.5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is FetchProfileError) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // صورة المستخدم في حالة الخطأ
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.red.withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Icon(
                                    Icons.error_outline,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // معلومات الخطأ
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 14,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 4),
                                        TextCustom(
                                          text: "---",
                                          fontSize: 5,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ThemeAwareLogo(
                    height: 50,
                    type: 'png',
                    borderRadius: 18,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
        ),

        body: SafeArea(
          child: BlocBuilder<MainCubit, int>(
            builder: (context, currentIndex) {
              return Stack(
                children: [
                  RefreshIndicator(
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    onRefresh: () async {
                      // Refresh profile data
                      context.read<ProfileCubit>().fetchProfile();
                    },
                    child: PageView(
                      controller: context.read<MainCubit>().pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        HomeScreen(),
                        VoterScreen(),
                        StripScreen(),
                        NotificationsScreen(),
                        SettingsScreen(),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            height: 70,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).hintColor.withOpacity(0.1),
                              // Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 15,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).canvasColor.withOpacity(0.1),
                                width: 0.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildNavItem(
                                      context: context,
                                      icon: Iconsax.home,
                                      index: 0,
                                      currentIndex: currentIndex,
                                    ),
                                    _buildNavItem(
                                      context: context,
                                      icon: Iconsax.tag_user,
                                      index: 1,
                                      currentIndex: currentIndex,
                                    ),
                                    _buildNavItem(
                                      context: context,
                                      icon: Iconsax.receipt_text,
                                      index: 2,
                                      currentIndex: currentIndex,
                                    ),
                                    _buildNavItem(
                                      context: context,
                                      icon: Iconsax.notification,
                                      index: 3,
                                      currentIndex: currentIndex,
                                    ),
                                    _buildNavItem(
                                      context: context,
                                      icon: Iconsax.setting_2,
                                      index: 4,
                                      currentIndex: currentIndex,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required int index,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => context.read<MainCubit>().navigateTo(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).canvasColor.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).canvasColor.withOpacity(0.6),
          size: isSelected ? 28 : 24,
        ),
      ),
    );
  }
}
