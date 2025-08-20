import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/features/management/notification/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h),
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.25),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.5.w),

        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).hintColor.withValues(alpha: 0.1),
                  radius: 2.25.h,
                  child: Icon(
                    Iconsax.notification,
                    size: MediaQuery.of(context).size.height * 0.025,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: TextCustom(
                          text: notification.title,
                          fontSize: 5.5,
                          height: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: 0.5.h),

                      TextCustom(
                        text: notification.body,
                        fontSize: 5.15,
                        maxLines: 10,
                        textAlign: TextAlign.start,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(height: 0.5.h),
                      TextCustom(
                        text: _formatDateTime(notification.createdAt),
                        fontSize: 4.5,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'قبل ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      return 'قبل ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else if (difference.inMinutes > 0) {
      return 'قبل ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
    } else {
      return 'الآن';
    }
  }
}
