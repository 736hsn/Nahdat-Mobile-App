import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/text.dart';
import 'loading_indicator.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    this.loading = false,
    this.color,
    this.textColor,
    this.title,
    required this.onTap,
    this.fontWeight,
    this.borderColor = Colors.transparent,
    this.width = 70,
    this.verticalPadding = 1.2,
    this.child,
  });
  final bool loading;
  final String? title;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final double width;
  final double verticalPadding;
  final FontWeight? fontWeight;
  final Color borderColor;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      child: MaterialButton(
        elevation: 0,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding.h,
          horizontal: 0.5.w,
        ),
        minWidth: double.infinity,
        color: color ?? Theme.of(context).primaryColor,
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.sp),
          side: BorderSide(color: borderColor, width: 0.5.w),
        ),
        child: !loading
            ? child ??
                  Padding(
                    padding: EdgeInsets.all(1.h),
                    child: TextCustom(
                      text: title!.tr(),
                      height: 1,
                      color: textColor ?? Colors.white,
                      fontSize: 5,
                      fontWeight: fontWeight ?? FontWeight.bold,
                    ),
                  )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: LoadingCustom(),
                ),
              ),
      ),
    );
  }
}
