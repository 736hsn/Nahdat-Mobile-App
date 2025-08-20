import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';

class DialogCustom extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final String imagePath;
  final String? imageType;
  final String? message;
  final Color? messageColor;
  final String? buttonTitle;
  final Color? backgroundColor;
  final Widget? action;
  final dynamic Function()? onTap;
  const DialogCustom({
    super.key,
    required this.title,
    required this.imagePath,
    this.imageType,
    this.titleColor,
    this.messageColor,
    this.message,
    this.buttonTitle,
    this.onTap,
    this.backgroundColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != '')
                ImageAssetCustom(
                  img: imagePath,
                  type: imageType ?? 'png',
                  height: 12.h,
                ),
              if (imagePath != '') SizedBox(height: 2.h),
              TextCustom(
                text: title,
                color: titleColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 7,
                maxLines: 3,
              ),
              if (message != null) SizedBox(height: 1.h),
              if (message != null)
                TextCustom(
                  text: message?.tr() ?? '',
                  color: messageColor ?? Colors.white,
                  maxLines: 4,
                  fontSize: 5,
                ),
              SizedBox(height: 2.h),
              action != null
                  ? action!
                  : ButtonCustom(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 60,
                      title: buttonTitle ?? 'تم',
                      onTap:
                          onTap ??
                          () {
                            context.pop();
                          },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
