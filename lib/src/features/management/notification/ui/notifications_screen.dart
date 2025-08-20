import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/core/common/cards/notification_card.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import '../logic/notification_cubit.dart';
import '../logic/notification_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // OneSignal initialization removed - it's already initialized in main.dart
    // Fetch notifications when screen initializes
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarCustom(title: 'الإشعارات'),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () => context.read<NotificationCubit>().fetchNotifications(),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          children: [
            SizedBox(height: 1.25.h),

            TextCustom(
              text: 'الإشعارات',
              fontSize: 5.5,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),

            SizedBox(height: 2.h),

            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (state is NotificationError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.close_circle, color: Colors.red, size: 48),
                        SizedBox(height: 16),
                        TextCustom(
                          text: state.error,
                          fontSize: 4.5,
                          color: Colors.red,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else if (state is NotificationSuccess) {
                  if (state.notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.notification,
                            color: Theme.of(context).hintColor,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          TextCustom(
                            text: 'لا توجد إشعارات',
                            fontSize: 4.5,
                            color: Theme.of(context).hintColor,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.notifications.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return NotificationCard(
                        notification: state.notifications[index],
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
