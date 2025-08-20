import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supervisor/src/core/common/widgets/BottomButtonWrapperCustom.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/text_form_field.dart';
import 'package:supervisor/src/core/common/widgets/theme_aware_logo.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';

import '../logic/login_cubit.dart';
import '../logic/login_state.dart';

class LoginWithPhoneNumberScreen extends StatefulWidget {
  const LoginWithPhoneNumberScreen({super.key});

  @override
  State<LoginWithPhoneNumberScreen> createState() =>
      _LoginWithPhoneNumberScreenState();
}

class _LoginWithPhoneNumberScreenState
    extends State<LoginWithPhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is SendOtpSuccess) {
            context.push('/verify-otp', extra: _phoneController.text);
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is SendOtpError) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            // );
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
                      SizedBox(height: 12.h),
                      _buildWelcomeSection(),
                      SizedBox(height: 8.h),
                      _buildPhoneSection(state),
                      SizedBox(height: 9.h),
                      // _buildEmailSignInSection(),
                      SizedBox(height: 8.h),
                      Center(child: _buildButtonsSection(state)),
                    ],
                  ),
                ),
              ),
              // BottomButtonWrapperCustom(
              //   bottomWidget: _buildButtonsSection(state),
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 5.w),
              //     child: Form(
              //       key: _formKey,
              //       child: ListView(
              //         children: [
              //           SizedBox(height: 12.h),
              //           _buildWelcomeSection(),
              //           SizedBox(height: 8.h),
              //           _buildPhoneSection(state),
              //           SizedBox(height: 9.h),
              //           // _buildEmailSignInSection(),
              //           SizedBox(height: 8.h),
              //           _buildButtonsSection(state),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Center(
      child: Column(
        children: [
          ImageAssetCustom(img: 'logo2', type: 'png', height: 20.h),
          SizedBox(height: 2.5.h),
          TextCustom(
            text: 'أهلا وسهلا بك',
            fontWeight: FontWeight.bold,
            fontSize: 8.5,
          ),
          SizedBox(height: 1.2.h),
          TextCustom(
            text:
                "نحن سعداء بعودتك! قم بتسجيل الدخول للوصول إلى حسابك والاستمتاع بتجربة شخصية",
            fontWeight: FontWeight.w600,
            maxLines: 10,
            fontSize: 5.25,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneSection(LoginState state) {
    String? sendOtpError;
    if (state is SendOtpError) {
      sendOtpError = state.error.tr();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 1.2.h),
        TextCustom(
          text: 'رقم الهاتف',

          color: Theme.of(context).colorScheme.primary,
          textAlign: TextAlign.start,
          isSubTitle: true,
          maxLines: 10,
          fontSize: 5,
        ),
        SizedBox(height: 1.2.h),
        LeftAlignedTextFormField(
          controller: _phoneController,
          hintText: '077000000000',
          prefixText: '',
          showRedStar: false,
          keyboardType: TextInputType.phone,
          errorText: sendOtpError,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء ادخال رقم الهاتف';
            } else if ((value.startsWith('07') && value.length < 11) ||
                (!value.startsWith('7') && !value.startsWith('07')) ||
                value.length < 10 ||
                value.length > 11) {
              return 'الرجاء ادخال رقم هاتف صالح';
            }
            return null;
          },
        ),
        SizedBox(height: 1.2.h),
        // TextFormFieldCustom(
        //   hintText: LocaleKeys.password.tr(),
        //   controller: _passwordController,
        //   validator: (String? value) {
        //     if (value == null || value.isEmpty) {
        //       return 'الرجاء ادخال كلمة السر';
        //     } else if (value.length < 8) {
        //       return 'كلمة المرور يجب أن لا تقل عن 8 أحرف أو أرقام';
        //     }
        //     return null;
        //   },
        // ),
        TextCustom(
          text: 'سنرسل رمز التحقق إلى رقم الهاتف الخاص بك',
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.secondary,
          textAlign: TextAlign.start,
          maxLines: 10,
          fontSize: 4.25,
        ),
      ],
    );
  }

  Widget _buildEmailSignInSection() {
    return GestureDetector(
      onTap: () {
        // context.push('/login-with-email');
      },
      child: Container(
        // width: double.infinity,
        // padding: EdgeInsets.only(top: 3.5.h, bottom: 2.5.h),
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Theme.of(
        //       context,
        //     ).colorScheme.secondary.withValues(alpha: 0.3),
        //   ),
        //   borderRadius: BorderRadius.circular(3.5.w),
        // ),
        // child: Column(
        //   children: [
        //     ImageLocalCustom(img: 'email', type: 'svg', height: 5.h),
        //     SizedBox(height: 1.5.h),
        //     TextCustom(
        //       text: LocaleKeys.signInWithEmail.tr(),
        //       fontSize: 5.5,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget _buildButtonsSection(LoginState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonCustom(
          title: 'ارسال رمز التحقق',
          width: 54,
          loading: state is SendOtpLoading,
          onTap: () {
            print("-----------NotsendedOtp-----------");

            if (_formKey.currentState?.validate() == true) {
              print("-----------sendedOtp-----------");
              context.read<LoginCubit>().sendOtp(_phoneController.text);
            }
          },
        ),
        SizedBox(width: 2.w),
        ButtonCustom(
          title: 'انشاء حساب جديد',
          color: Theme.of(context).colorScheme.surface,
          textColor: Theme.of(context).colorScheme.primary,
          borderColor: Theme.of(context).colorScheme.primary,
          width: 34,
          onTap: () {
            context.push('/register');
          },
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
