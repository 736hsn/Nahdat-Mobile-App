import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/text.dart';

class MessageWidgetCustom extends StatelessWidget {
  final double? verticalPadding;
  final double? horizontalPadding;
  final double spaceBetweenIconAndMessage;

  final String message;
  final double? messageSize;
  final Color? messageColor;

  final bool isIconVisible;
  final IconData? iconData;
  final double iconSize;
  final Color? iconColor;

  const MessageWidgetCustom({
    super.key,
    required this.message,
    this.iconData,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.spaceBetweenIconAndMessage = 0.5,
    this.iconSize = 6,
    this.messageSize,
    this.isIconVisible = false,
    this.messageColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding!.h,
          horizontal: horizontalPadding!.w,
        ),
        child: Column(
          children: [
            if (isIconVisible)
              Icon(
                iconData ?? Iconsax.document,
                color: iconColor ?? Theme.of(context).colorScheme.secondary,
                size: iconSize.w,
              ),
            if (isIconVisible) SizedBox(height: spaceBetweenIconAndMessage.h),
            TextCustom(
              text: message,
              fontSize: messageSize ?? 4,
              color: messageColor ?? Theme.of(context).hintColor,
              fontWeight: FontWeight.bold,
            ),
            // SizedBox(height: 1.h),
            // ButtonCustom(
            //   color: Theme.of(context).colorScheme.surface,
            //   textColor: Theme.of(context).colorScheme.primary,
            //   borderColor: Theme.of(context).colorScheme.primary,
            //   onTap: onRetry,
            //   verticalPadding: 0.8,
            //   title: 'إعادة المحاولة',
            //   width: 34,
            // ),
          ],
        ),
      ),
    );
  }
}
