import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supervisor/src/core/common/widgets/BottomButtonWrapperCustom.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/theme_aware_logo.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/core/theme/colors.dart';
import 'package:supervisor/src/core/utils/functions/CountdownTimerMixin.dart';
import 'package:supervisor/src/features/main/logic/preload.dart';
import '../logic/login_cubit.dart';
import '../logic/login_state.dart';
import 'dart:ui' as ui;

class VerifyOtpCodeScreen extends StatefulWidget {
  final String phoneNumber;
  const VerifyOtpCodeScreen({super.key, required this.phoneNumber});

  @override
  State<VerifyOtpCodeScreen> createState() => _VerifyOtpCodeScreenState();
}

class _VerifyOtpCodeScreenState extends State<VerifyOtpCodeScreen>
    with CountdownTimerMixin {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _apiError;

  @override
  void initState() {
    super.initState();
    startTimer(seconds: 300);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is VerifyOtpSuccess) {
            PreloadService().preloadData(context);

            // Future.delayed(const Duration(seconds: 1));
            context.go('/main');
          } else if (state is VerifyOtpError) {
            setState(() {
              _apiError = state.error;
            });
            _formKey.currentState?.validate();
          } else if (state is ResendOtpSuccess) {
            startTimer(seconds: 300);
            _otpController.clear();
            setState(() {
              _apiError = null;
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              _buildEffect(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(height: 14.h),
                      _buildWelcomeSection(),
                      SizedBox(height: 6.h),
                      _buildOtpCodeTextFieldSection(context),
                      SizedBox(height: 0.5.h),
                      _buildRequestOtpAgainMessage(),
                      SizedBox(height: 10.h),
                      Center(child: _buildButtonsSection(state)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildWelcomeSection() {
    return Center(
      child: Column(
        children: [
          ThemeAwareLogo(
            type: 'png',
            height: 10.h,
            color: AppColors.primaryLight,
          ),
          SizedBox(height: 7.h),
          TextCustom(
            text: 'أدخل رمز التحقق',
            fontWeight: FontWeight.bold,
            fontSize: 8.5,
          ),
          SizedBox(height: 1.2.h),
          TextCustom(
            text: 'أدخل رمز التحقق',
            fontWeight: FontWeight.w600,
            maxLines: 10,
            fontSize: 5.25,
          ),
        ],
      ),
    );
  }

  _buildOtpCodeTextFieldSection(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(
          context,
        ).textTheme.copyWith(bodySmall: TextStyle(fontFamily: 'Cairo')),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: PinCodeTextField(
            appContext: context,
            autovalidateMode: AutovalidateMode.disabled,
            errorTextSpace: 3.h,
            errorTextDirection: locale != Locale('en', 'US')
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
            pastedTextStyle: TextStyle(
              color: Theme.of(context).disabledColor,
              fontWeight: FontWeight.bold,
            ),
            length: 4,
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              borderRadius: BorderRadius.circular(4.sp),
              shape: PinCodeFieldShape.box,
              inactiveBorderWidth: 0.6.sp,
              disabledBorderWidth: 0.6.sp,
              activeBorderWidth: 0.6.sp,

              selectedBorderWidth: 0.65.sp,

              activeColor: Theme.of(context).primaryColor.withOpacity(0.8),

              // activeColor: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              selectedColor: Theme.of(context).primaryColor,
              selectedFillColor: Theme.of(context).primaryColor,
              inactiveColor: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.4),
              inactiveFillColor: Theme.of(context).dialogBackgroundColor,
              fieldHeight: 7.h,
              fieldWidth: 7.h,
              activeFillColor: Theme.of(context).dialogBackgroundColor,
            ),
            cursorColor: Theme.of(context).disabledColor,
            textStyle: TextStyle(
              color: Theme.of(context).disabledColor,
              fontWeight: FontWeight.bold,
            ),
            animationDuration: const Duration(milliseconds: 300),
            controller: _otpController,
            keyboardType: TextInputType.number,
            enablePinAutofill: true,
            animationCurve: Curves.fastOutSlowIn,
            beforeTextPaste: (text) => true,
            onChanged: (value) {
              if (_apiError != null) {
                setState(() {
                  _apiError = null;
                });
              }
            },
            validator: (String? value) {
              if (_apiError != null) {
                return _apiError?.tr();
              }
              if (value == null || value.isEmpty) {
                return 'الرجاء أدخل رمز التحقق';
              } else if (value.length < 4) {
                return 'رمز التحقق يجب أن يكون 6 أرقام';
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'الرجاء أدخل رمز التحقق الصالح';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  _buildRequestOtpAgainMessage() {
    if (canResend) {
      return TextCustom(
        text: 'يمكنك إعادة ارسال رمز التحقق الآن',
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
        textAlign: TextAlign.start,
        fontSize: 4.75,
      );
    }

    return Row(
      children: [
        TextCustom(
          text: 'يمكنك إعادة ارسال رمز التحقق',
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 4.75,
        ),
        SizedBox(width: 0.5.w),
        TextCustom(
          text: formattedTime,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          textAlign: TextAlign.start,
          fontSize: 4.75,
        ),
        if (remainingSeconds >= 60) ...[
          SizedBox(width: 0.5.w),
          TextCustom(
            text: 'دقائق',
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
            fontSize: 4.75,
          ),
        ] else if (remainingSeconds > 0) ...[
          SizedBox(width: 0.5.w),
          TextCustom(
            text: 'ثوان',
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
            fontSize: 4.75,
          ),
        ],
      ],
    );
  }

  _buildButtonsSection(LoginState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonCustom(
          title: 'تسجيل الدخول',
          width: 54,
          loading: state is VerifyOtpLoading,
          onTap: () {
            setState(() {
              _apiError = null;
            });
            if (_formKey.currentState!.validate()) {
              context.read<LoginCubit>().verifyOtp(_otpController.text);
            }
          },
        ),
        SizedBox(width: 2.w),
        ButtonCustom(
          title: 'طلب رمز تحقق جديد',
          color: Theme.of(context).colorScheme.surface,
          textColor: canResend
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
          borderColor: canResend
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6),
          width: 34,
          loading: state is SendOtpLoading,
          onTap: canResend
              ? () {
                  context.read<LoginCubit>().sendOtp(
                    widget.phoneNumber,
                    isResend: true,
                  );
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildEffect() {
    return Positioned(
      child: ImageAssetCustom(
        img: 'background-effect-grey',
        fit: BoxFit.cover,
        type: 'png',
        height: 100.h,
        width: 100.w,
      ),
    );
  }
}
