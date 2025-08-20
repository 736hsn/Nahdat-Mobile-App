import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class IconButtonCustom extends StatelessWidget {
  final IconData iconData;
  final Function() onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isLoading;
  final bool isBold;
  final bool isBackgroundColorVisible;
  final double? iconSize;
  final Color? iconColor;
  final Color? backgroundColor;

  const IconButtonCustom({
    super.key,
    required this.iconData,
    required this.onTap,
    this.padding,
    this.margin,
    this.isLoading = false,
    this.isBold = false,
    this.isBackgroundColorVisible = false,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 1.5.w),
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.h),
          color:
              isBackgroundColorVisible
                  ? backgroundColor ??
                      Theme.of(context).colorScheme.secondaryContainer
                  : Colors.transparent,
        ),
        child:
            isLoading
                ? LoadingCustom()
                : isBold
                ? Text(
                  String.fromCharCode(iconData.codePoint),
                  style: TextStyle(
                    fontFamily: iconData.fontFamily,
                    fontSize: iconSize?.w ?? 7.5.w,
                    color: iconColor ?? Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    package: iconData.fontPackage,
                  ),
                )
                : Icon(
                  iconData,
                  color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
                  size: iconSize?.w ?? 7.5.w,
                ),
      ),
    );
  }
}
