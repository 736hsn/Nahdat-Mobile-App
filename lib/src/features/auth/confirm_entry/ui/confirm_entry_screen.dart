import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';
import 'package:supervisor/src/core/common/widgets/loading_indicator.dart';
import 'package:supervisor/src/core/common/widgets/DialogCustom.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';
import '../logic/confirm_entry_cubit.dart';
import '../logic/confirm_entry_state.dart';

class ConfirmEntryScreen extends StatefulWidget {
  const ConfirmEntryScreen({super.key});

  @override
  State<ConfirmEntryScreen> createState() => _ConfirmEntryScreenState();
}

class _ConfirmEntryScreenState extends State<ConfirmEntryScreen> {
  @override
  void initState() {
    super.initState();
    // Check location when screen loads
    context.read<ConfirmEntryCubit>().checkCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: TextCustom(
          text: 'تأكيد الدخول',
          fontSize: 6,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<ConfirmEntryCubit, ConfirmEntryState>(
        listener: (context, state) {
          if (state is ConfirmEntryError) {
            showDialog(
              context: context,
              builder: (context) => DialogCustom(
                title: 'خطأ',
                imagePath: 'error',
                imageType: 'svg',
                message: state.error,
                backgroundColor: Colors.red,
                buttonTitle: 'حسناً',
                onTap: () => Navigator.pop(context),
              ),
            );
          } else if (state is ConfirmEntrySuccess) {
            showDialog(
              context: context,
              builder: (context) => DialogCustom(
                backgroundColor: Colors.green,
                title: 'تم بنجاح',
                imagePath: 'success',
                imageType: 'svg',
                message: state.message,
                buttonTitle: 'حسناً',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo and title section
                  _buildHeaderSection(),
                  const SizedBox(height: 30),

                  // Location status card
                  _buildLocationStatusCard(state),
                  const SizedBox(height: 30),

                  // Captured image section
                  _buildCapturedImageSection(state),
                  const SizedBox(height: 30),

                  // Action buttons
                  _buildActionButtons(state),
                  const SizedBox(height: 30),

                  // Instructions section
                  _buildInstructionsSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: ImageAssetCustom(
              img: 'logo',
              type: 'png',
              height: 60,
              width: 60,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Title
        TextCustom(
          text: 'تأكيد الدخول إلى مركز التصويت',
          fontSize: 7,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Subtitle
        TextCustom(
          text:
              'يرجى التأكد من وجودك داخل مركز التصويت والتقاط صورة واضحة لوجهك',
          fontSize: 5,
          color: Colors.grey[600] ?? Colors.grey,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildLocationStatusCard(ConfirmEntryState state) {
    Color cardColor;
    Color iconColor;
    IconData iconData;
    String statusText;
    String descriptionText;

    if (state is ConfirmEntryLocationSuccess) {
      if (state.isInsidePollingCenter) {
        cardColor = Colors.green;
        iconColor = Colors.green;
        iconData = Iconsax.location_tick;
        statusText = 'داخل مركز التصويت';
        descriptionText = 'موقعك محدد بنجاح - يمكنك المتابعة';
      } else {
        cardColor = Colors.red;
        iconColor = Colors.red;
        iconData = Iconsax.location_cross;
        statusText = 'خارج مركز التصويت';
        descriptionText =
            'تبعد ${state.distanceInMeters.round()} متر عن المركز';
      }
    } else if (state is ConfirmEntryLocationChecking) {
      cardColor = Colors.orange;
      iconColor = Colors.orange;
      iconData = Iconsax.gps;
      statusText = 'جاري تحديد الموقع...';
      descriptionText = 'يرجى الانتظار';
    } else if (state is ConfirmEntryLocationError) {
      cardColor = Colors.red;
      iconColor = Colors.red;
      iconData = Iconsax.location_cross;
      statusText = 'خطأ في تحديد الموقع';
      descriptionText = state.error;
    } else {
      cardColor = Colors.grey;
      iconColor = Colors.grey;
      iconData = Iconsax.location;
      statusText = 'لم يتم تحديد الموقع';
      descriptionText = 'اضغط لتحديد موقعك';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(iconData, color: iconColor, size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      text: statusText,
                      fontSize: 5.5,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                    const SizedBox(height: 5),
                    TextCustom(
                      text: descriptionText,
                      fontSize: 4.5,
                      color: Colors.grey[600] ?? Colors.grey,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (state is ConfirmEntryLocationChecking) ...[
            const SizedBox(height: 15),
            const LoadingCustom(),
          ],
        ],
      ),
    );
  }

  Widget _buildCapturedImageSection(ConfirmEntryState state) {
    final cubit = context.read<ConfirmEntryCubit>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Iconsax.camera, color: Colors.blue, size: 24),
              const SizedBox(width: 15),
              TextCustom(
                text: 'صورة الوجه',
                fontSize: 5.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Image preview
          if (cubit.capturedImagePath != null)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: FileImage(File(cubit.capturedImagePath!)),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(Iconsax.camera, color: Colors.grey[400], size: 40),
            ),

          const SizedBox(height: 15),

          TextCustom(
            text: cubit.capturedImagePath != null
                ? 'تم التقاط الصورة بنجاح'
                : 'لم يتم التقاط صورة بعد',
            fontSize: 4.5,
            color: cubit.capturedImagePath != null
                ? Colors.green
                : Colors.grey[600] ?? Colors.grey,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ConfirmEntryState state) {
    final cubit = context.read<ConfirmEntryCubit>();
    final isLocationValid =
        state is ConfirmEntryLocationSuccess && state.isInsidePollingCenter;

    return Column(
      children: [
        // Refresh location button
        ButtonCustom(
          title: 'تحديث الموقع',
          onTap: () => cubit.checkCurrentLocation(),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        const SizedBox(height: 15),

        // Take photo button
        ButtonCustom(
          title: 'التقاط صورة الوجه',
          onTap: isLocationValid && state is! ConfirmEntryCameraOpening
              ? () => cubit.openFaceCamera(context)
              : null,
          color: isLocationValid ? Colors.green : Colors.grey,
          textColor: Colors.white,
        ),
        const SizedBox(height: 15),

        // Confirm entry button
        ButtonCustom(
          title: state is ConfirmEntrySubmitting
              ? 'جاري التأكيد...'
              : 'تأكيد الدخول',
          onTap:
              isLocationValid &&
                  cubit.capturedImagePath != null &&
                  state is! ConfirmEntrySubmitting
              ? () => cubit.submitEntryConfirmation()
              : null,
          color: isLocationValid && cubit.capturedImagePath != null
              ? Colors.orange
              : Colors.grey,
          textColor: Colors.white,
          loading: state is ConfirmEntrySubmitting,
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.info_circle, color: Colors.blue, size: 24),
              const SizedBox(width: 10),
              TextCustom(
                text: 'تعليمات مهمة',
                fontSize: 5.5,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 15),

          _buildInstructionItem(
            '1. تأكد من وجودك داخل مركز التصويت (نطاق 50 متر)',
          ),
          _buildInstructionItem(
            '2. التقط صورة واضحة لوجهك باستخدام الكاميرا الأمامية',
          ),
          _buildInstructionItem('3. اضغط على "تأكيد الدخول" لإرسال البيانات'),
          _buildInstructionItem('4. احتفظ بالتطبيق مفتوح حتى تأكيد العملية'),
          _buildInstructionItem(
            '5. في حالة ظهور شاشة سوداء، تأكد من تفعيل صلاحية الكاميرا',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.blue, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextCustom(
              text: text,
              fontSize: 4.5,
              color: Colors.grey[700] ?? Colors.grey,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
