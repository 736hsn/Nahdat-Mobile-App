import 'package:flutter/material.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';

class BottomButtonWrapperCustom extends StatelessWidget {
  final Widget child;
  final String? buttonTitle;
  final VoidCallback? onButtonTap;
  final double? buttonHeight;
  final double? buttonBottomPadding;
  final double? buttonHorizontalPadding;
  final double? buttonVerticalPadding;
  final bool? isLoading;
  final Color? containerColor;
  final Widget? bottomWidget;

  const BottomButtonWrapperCustom({
    super.key,
    required this.child,
    this.buttonTitle,
    this.onButtonTap,
    this.buttonHeight,
    this.buttonBottomPadding,
    this.buttonHorizontalPadding,
    this.buttonVerticalPadding,
    this.isLoading,
    this.containerColor,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: 100.w,
            height: buttonHeight ?? 10.75.h,
            color: containerColor ?? Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(
              horizontal: buttonHorizontalPadding ?? 5.w,
              vertical: buttonVerticalPadding ?? 2.h,
            ),
            margin: EdgeInsets.symmetric(vertical: 0.h),
            child:
            bottomWidget ??
                ButtonCustom(
                  verticalPadding: 1.5,
                  loading: isLoading ?? false,
                  title: buttonTitle ?? 'save',
                  onTap: onButtonTap ?? () {},
                ),
          ),
        ),
      ],
    );
  }
}
