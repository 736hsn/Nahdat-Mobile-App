// import 'package:supervisor/src/core/sizing/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:iconsax/iconsax.dart';

// import '../widgets/text.dart';
// import 'icon_button.dart';

// class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
//   final String title;

//   const AppBarCustom({super.key, required this.title});

//   @override
//   Size get preferredSize => Size.fromHeight(8.5.h);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             width: 0.1,
//             color: Theme.of(context).indicatorColor.withValues(alpha: 0.2),
//           ),
//         ),
//       ),
//       child: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 5.w),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,

//               children: [
//                 Expanded(
//                   child: TextCustom(
//                     text: title,

//                      fontSize: 7,
//                     textAlign: TextAlign.start,

//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 SizedBox(width: 13.w),
//                 IconButtonCustom(
//                   iconData: Iconsax.arrow_left,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 0.25.w,
//                     vertical: 0.25.w,
//                   ),
//                   onTap: () {
//                     context.pop();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/core/common/widgets/icon_button.dart';
import 'package:supervisor/src/core/common/widgets/shimmer_container.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_cubit.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_state.dart';

import '../../utils/functions/functions.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHomeScreen;
  final bool isNotificationButtonVisible;
  final bool isBackButtonVisible;

  AppBarCustom({
    super.key,
    required this.title,
    this.isHomeScreen = false,
    this.isNotificationButtonVisible = false,
    this.isBackButtonVisible = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(8.5.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isHomeScreen)
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is FetchProfileSuccess) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              text: "اهلا بك",
                              fontSize: 5.4,
                              fontWeight: FontWeight.w300,
                              height: 0.95,
                            ),
                            SizedBox(
                              width: 60.w,
                              child: TextCustom(
                                textAlign: TextAlign.start,
                                text: state.profile.fullName,
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      } else if (state is FetchProfileLoading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerContainerCustom(
                              height: 1.5,
                              width: 20,
                              borderRadius: 3.5,
                            ),
                            SizedBox(height: 1.h),
                            ShimmerContainerCustom(
                              height: 2,
                              width: 30,
                              borderRadius: 3.5,
                            ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
               
               
               
                if (!isHomeScreen)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        text: title,
                        fontSize: isHomeScreen ? 8.5 : 6.5,
                        fontWeight: isHomeScreen
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ],
                  ),
                Expanded(child: SizedBox()),

                // if (isHomeScreen)
                //   IconButtonCustom(
                //     iconData: Iconsax.calendar_1,
                //     isBackgroundColorVisible: true,
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 1.5.w,
                //       vertical: 1.5.w,
                //     ),
                //     onTap: () {},
                //   ),
                if (isNotificationButtonVisible) SizedBox(width: 3.w),
                if (isNotificationButtonVisible)
                  IconButtonCustom(
                    iconData: Iconsax.notification,
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.5.w,
                      vertical: 1.5.w,
                    ),
                    onTap: () {
                      context.go("/notifications");
                    },
                  ),
                if (isBackButtonVisible) SizedBox(width: 3.w),
                if (isBackButtonVisible)
                  IconButtonCustom(
                    iconData: Iconsax.arrow_left,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.25.w,
                      vertical: 0.25.w,
                    ),
                    onTap: () {
                      context.pop();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
