import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/button.dart';
import '../../common/widgets/text.dart';
import '../../di/dependency_injection.dart';

class LanguageFunctions {
  static void changeLanguage(BuildContext context, String code) {
    if (code == 'en') {
      context.setLocale(const Locale('en', 'US'));
      sharedPreferences!.setString('language', 'en');
    } else if (code == 'ar') {
      sharedPreferences!.setString('language', 'ar');
      context.setLocale(const Locale('ar', 'DZ'));
    } else {
      sharedPreferences!.setString('language', 'fa');
      context.setLocale(const Locale('fa', 'IR'));
    }
  }

  static bool englishCheck(BuildContext context) {
    return Localizations.localeOf(context).toString() == 'en_US';
  }

  static Locale getStartingLanguage() {
    return sharedPreferences!.getString('language') == null ||
            sharedPreferences!.getString('language') == 'en'
        ? const Locale('en', 'US')
        : sharedPreferences!.getString('language') == 'fa'
        ? const Locale('fa', 'IR')
        : const Locale('ar', 'DZ');
  }

  static void showLanguageBottomSheet(
    BuildContext context,
    bool isDarkMode,
    bool isOnLandingPage,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? Theme.of(context).colorScheme.secondary.withAlpha(51)
                    : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextCustom(
                text: 'language'.tr(),
                fontSize: 6.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 1.h),
              ButtonCustom(
                onTap: () {
                  LanguageFunctions.changeLanguage(context, 'ar');
                },
                color:
                    isDarkMode
                        ? Theme.of(context).colorScheme.secondary.withAlpha(51)
                        : Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextCustom(text: 'arabic'.tr()),
                      Container(
                        height: 2.h,
                        width: 2.h,
                        padding: EdgeInsets.all(0.4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color!,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            color:
                                Localizations.localeOf(context).toString() ==
                                        'ar_DZ'
                                    ? Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color!
                                    : Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              ButtonCustom(
                onTap: () {
                  LanguageFunctions.changeLanguage(context, 'en');
                },
                color:
                    isDarkMode
                        ? Theme.of(context).colorScheme.secondary.withAlpha(51)
                        : Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextCustom(text: 'english'.tr()),
                      Container(
                        height: 2.h,
                        width: 2.h,
                        padding: EdgeInsets.all(0.4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color!,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            color:
                                Localizations.localeOf(context).toString() ==
                                        'en_US'
                                    ? Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color!
                                    : Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              ButtonCustom(
                onTap: () {
                  LanguageFunctions.changeLanguage(context, 'fa');
                },
                color:
                    isDarkMode
                        ? Theme.of(context).colorScheme.secondary.withAlpha(51)
                        : Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextCustom(text: 'kurdish'.tr()),
                      Container(
                        height: 2.h,
                        width: 2.h,
                        padding: EdgeInsets.all(0.4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color!,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            color:
                                Localizations.localeOf(context).toString() ==
                                        'fa_IR'
                                    ? Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color!
                                    : Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isOnLandingPage ? SizedBox(height: 3.h) : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
