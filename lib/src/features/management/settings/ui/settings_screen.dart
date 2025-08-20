import 'package:shimmer/shimmer.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';
import 'package:supervisor/src/core/common/widgets/image_network.dart';
import 'package:supervisor/src/core/common/widgets/shimmer_container.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/core/theme/theme_cubit.dart';
import 'package:supervisor/src/features/home/logic/home_cubit.dart';
import 'package:supervisor/src/core/services/auth_service.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_cubit.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () async {
          // await context.read<HomeCubit>().fetchHomeData();
        },
        child: ListView(
          physics: const ScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          children: [
            SizedBox(height: 1.25.h),

            _buildProfileCardSection(),

            SizedBox(height: 1.5.h),

            _buildSettingsCard(
              context,
              title: 'المعلومات الشخصية',
              onTap: () {
                context.pushNamed('profile');
              },
              iconData: Iconsax.info_circle,
            ),

            _buildSettingsCard(
              context,
              title: "مراكز التصويت التابعة لي",
              onTap: () {
                context.pushNamed('polling_centers');
              },
              iconData: Iconsax.info_circle,
            ),
            _buildSettingsCard(
              context,
              title: 'من نحن ؟',
              onTap: () {
                context.pushNamed('about_us');
              },
              iconData: Iconsax.info_circle,
            ),

            _buildSettingsCard(
              context,
              title: "اتصل بنا",
              onTap: () {
                context.pushNamed('contact_us');
              },
              iconPath: 'support-outline',
              iconImageSize: 2.85.h,
            ),

            _buildSettingsCard(
              context,
              title: "الاسئلة الشائعة",
              onTap: () {
                context.pushNamed('faq');
              },
              iconData: Iconsax.document,
            ),

            _buildSettingsCard(
              context,
              title: "سياسة الخصوصية",
              onTap: () {
                context.pushNamed('privacy_policy');
              },
              iconData: Iconsax.document,
            ),

            _buildSettingsCard(
              context,
              title: "الوضع المظلم",

              onTap: () {
                _showThemePicker(context);
              },
              iconData: Iconsax.colorfilter,
            ),

            // Only show logout if user is logged in
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                final authService = getIt<AuthService>();
                if (authService.isAuthenticated) {
                  return _buildSettingsCard(
                    context,
                    title: "تسجيل الخروج",
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                    iconData: Iconsax.logout,
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            SizedBox(height: 11.25.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {

    required String title,
    String? iconPath,
    double? iconImageSize,
    IconData? iconData,
    Widget? trailing,

    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.55.h),
        padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(3.5.w),
          // border: Border.all(
          //   color: Theme.of(
          //     context,
          //   ).colorScheme.secondary.withValues(alpha: 0.25),
          // ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).hintColor.withValues(alpha: 0.1),
                  radius: 2.25.h,
                  child: iconPath == null
                      ? Icon(
                          iconData,
                          size: MediaQuery.of(context).size.height * 0.025,
                          color: Theme.of(context).canvasColor,
                        )
                      : ImageAssetCustom(
                          img: iconPath,
                          type: 'svg',
                          height: iconImageSize ?? 3.h,
                          color: Theme.of(context).canvasColor,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.025,
                  ),
                  child: TextCustom(
                    text: title,
                    fontSize: 5,
                    height: 1,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            trailing ??
                Icon(
                  // // languageController.languageNow != "English"
                  //     ? Iconsax.arrow_left_24
                  //     :
                  Iconsax.arrow_left_24,
                  // Iconsax.arrow_right_34,
                  size: 2.5.h,
                  color: Theme.of(context).canvasColor,
                ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const TextCustom(
            text: 'تسجيل الخروج',
            fontSize: 6,
            fontWeight: FontWeight.bold,
          ),
          content: const TextCustom(
            text: 'هل أنت متأكد من تسجيل الخروج؟',
            fontSize: 5,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const TextCustom(
                text: 'إلغاء',
                fontSize: 5,
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () async {
                final authService = getIt<AuthService>();
                await authService.logout();

                if (context.mounted) {
                  Navigator.of(context).pop();
                  context.go('/login');
                }
              },
              child: const TextCustom(
                text: 'تسجيل الخروج',
                fontSize: 5,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
              TextCustom(
                text: "اختر الوضع",
                textAlign: TextAlign.center,
                fontSize: 6,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 2.h),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildRadioListTile(
                        context,
                        title: "فاتح",
                        value: ThemeMode.light,
                        groupValue: state.themeMode,
                      ),
                      _buildRadioListTile(
                        context,
                        title: "داكن",
                        value: ThemeMode.dark,
                        groupValue: state.themeMode,
                      ),
                      _buildRadioListTile(
                        context,
                        title: "النظام",
                        value: ThemeMode.system,
                        groupValue: state.themeMode,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 1.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioListTile(
    BuildContext context, {
    required String title,
    required ThemeMode value,
    required ThemeMode groupValue,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<ThemeCubit>().setThemeMode(value);
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(color: Theme.of(context).hintColor, width: 1),
        ),
        margin: EdgeInsets.symmetric(vertical: 0.8.h),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              activeColor: Theme.of(context).canvasColor,
              onChanged: (ThemeMode? newValue) {
                if (newValue != null) {
                  context.read<ThemeCubit>().setThemeMode(newValue);
                  Navigator.of(context).pop();
                }
              },
            ),
            SizedBox(width: 2.w),
            TextCustom(
              text: title,
              fontSize: 5,
              color: Theme.of(context).canvasColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCardSection() {
    return Stack(
      children: [
        Positioned.fill(
          child: ImageAssetCustom(
            borderRadius: 6,
            fit: BoxFit.cover,
            img: 'card-background',
            type: 'svg',
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4.75.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.sp),
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.95),
          ),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is FetchProfileSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 4.3.h,
                      backgroundColor: Theme.of(context).cardColor,
                      child: ImageNetworkCustom(
                        height: 7.8,
                        width: 17,
                        radius: 50,
                        url: state.profile.imagePath ?? '',
                        onEmptyIconSize: 3,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    TextCustom(
                      text: state.profile.fullName,
                      fontSize: 6.5,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    SizedBox(height: 0.1.h),
                    TextCustom(
                      text: state.profile.phone,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 5,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.2.h),
                  ],
                );
              } else if (state is FetchProfileLoading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        radius: 4.3.h,
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    ShimmerContainerCustom(
                      height: 2,
                      width: 35,
                      borderRadius: 3.5,
                    ),

                    SizedBox(height: 0.65.h),
                    ShimmerContainerCustom(
                      height: 1.5,
                      width: 22.5,
                      borderRadius: 3.5,
                    ),

                    SizedBox(height: 0.2.h),
                  ],
                );
              }
              return SizedBox(
                height: 14.75.h,
                child: Center(
                  child: TextCustom(
                    text: 'حدث خطأ ما',
                    color: Theme.of(context).cardColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
