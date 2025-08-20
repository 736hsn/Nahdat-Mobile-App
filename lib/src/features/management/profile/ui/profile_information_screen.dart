import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';
import 'package:supervisor/src/core/common/widgets/DialogCustom.dart';
import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';
import 'package:supervisor/src/core/common/widgets/image_network.dart';
import 'package:supervisor/src/core/common/widgets/shimmer_container.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/text_form_field.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/features/voter/models/voter_model.dart';

import '../logic/profile/profile_cubit.dart';
import '../logic/profile/profile_state.dart';

class ProfileInformationScreen extends StatefulWidget {
  const ProfileInformationScreen({super.key});

  @override
  State<ProfileInformationScreen> createState() =>
      _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController businessName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "الحساب الشخصي"),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () => context.read<ProfileCubit>().fetchProfile(),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              children: [
                SizedBox(height: 1.25.h),
                _buildProfileCardSection(),
                SizedBox(height: 1.5.h),
                _buildTextFieldsSection(),
                SizedBox(height: 1.5.h),
                _buildPollingCenterInfoSection(),
                SizedBox(height: 2.5.h),
                // _buildSaveButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCardSection() {
    return Stack(
      children: [
        Positioned.fill(
          child: ImageAssetCustom(
            borderRadius: 6,
            fit: BoxFit.cover,
            img: 'card-background',
            type: 'svg',
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4.75.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.sp),
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.95),
          ),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is FetchProfileSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      // onTap: () async {
                      //   final image = await imagePicker.pickAndProcessImage(
                      //     context,
                      //   );
                      //   if (image != null) {
                      //     context.read<ProfileCubit>().selectImage(image);
                      //   }
                      // },
                      child: CircleAvatar(
                        radius: 4.3.h,
                        backgroundColor: Theme.of(context).cardColor,
                        child: state.selectedImage == null
                            ? ImageNetworkCustom(
                                height: 7.8,
                                width: 17,
                                radius: 50,
                                url: state.profile.imagePath ?? "",
                                onEmptyIconSize: 3,
                              )
                            : ImageLocalCustom(
                                isFileImage: true,
                                height: 7.8,
                                width: 17,
                                borderRadius: 50,
                                img: state.selectedImage!.path,
                              ),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    TextCustom(
                      text: state.profile.fullName,
                      fontSize: 6.5,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    SizedBox(height: 0.1.h),
                    TextCustom(
                      text: state.profile.phone,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 5,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.2.h),
                  ],
                );
              } else if (state is FetchProfileLoading ||
                  state is EditProfileLoading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        radius: 4.3.h,
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    ShimmerContainerCustom(
                      height: 2,
                      width: 35,
                      borderRadius: 3.5,
                    ),

                    SizedBox(height: 0.65.h),
                    ShimmerContainerCustom(
                      height: 1.5,
                      width: 22.5,
                      borderRadius: 3.5,
                    ),
                    SizedBox(height: 0.2.h),
                  ],
                );
              }
              return SizedBox(
                height: 14.75.h,
                child: Center(
                  child: TextCustom(
                    text: "حدث خطأ ما",
                    color: Theme.of(context).cardColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldsSection() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is FetchProfileSuccess) {
          name.text = state.profile.fullName;
          businessName.text = state.profile.fullName;
          phone.text = state.profile.phone;
          birthday.text = state.profile.yearOfBirth ?? "";
        }
      },
      builder: (context, state) {
        if (state is FetchProfileSuccess) {
          name.text = state.profile.fullName;
          businessName.text = state.profile.fullName;
          phone.text = state.profile.phone;
          birthday.text = state.profile.yearOfBirth ?? "";
          print(birthday.text);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCustom(
              text: "الاسم",
              fontSize: 5,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 1.h),
            TextFormFieldCustom(
              hintText: "الاسم",
              readOnly: true,

              controller: name,
            ),

            SizedBox(height: 1.h),
            TextCustom(
              text: "رقم الهاتف",
              fontSize: 5,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 1.h),
            TextFormFieldCustom(
              hintText: "رقم الهاتف",
              controller: phone,
              prefixText: "",
              readOnly: true,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 1.h),
            TextCustom(
              text: "تاريخ الميلاد",
              fontSize: 5,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 1.h),
            TextFormFieldCustom(
              readOnly: true,

              hintText: "تاريخ الميلاد",
              controller: birthday,
              prefixText: "",
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 2.5.h),
          ],
        );
      },
    );
  }

  Widget _buildPollingCenterInfoSection() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is FetchProfileSuccess) {
          final pollingCenter = state.profile.pollingCenter;
          final side = state.profile.side;
          final area = state.profile.area;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(
                color: Theme.of(context).hintColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.5.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Icon(
                        Iconsax.location,
                        color: Theme.of(context).primaryColor,
                        size: 5.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            text: 'معلومات المركز ',
                            fontSize: 5.5,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: 0.3.h),
                          TextCustom(
                            text: pollingCenter.actualName,
                            fontSize: 4.5,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).hintColor,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Main Info Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'رقم المركز',
                        pollingCenter.number,
                        Iconsax.hashtag,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildInfoCard(
                        'عدد المحطات',
                        pollingCenter.stationCount.toString(),
                        Iconsax.buildings,
                        Colors.green,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Location Details
                _buildDetailSection('تفاصيل الموقع', [
                  _buildDetailRow('العنوان الكامل:', pollingCenter.address),
                  _buildDetailRow(
                    'المنطقة الفرعية:',
                    pollingCenter.newSubdistrict,
                  ),
                  _buildDetailRow('الجانب:', side.name),
                  _buildDetailRow('المنطقة:', area.name),
                ]),

                SizedBox(height: 2.h),

                // Additional Info
                _buildDetailSection('معلومات إضافية', [
                  _buildDetailRow('اسم المركز:', pollingCenter.name),
                  if (pollingCenter.code.isNotEmpty)
                    _buildDetailRow('كود المحافظة:', pollingCenter.code),
                  _buildDetailRow(
                    'الاسم على البطاقة:',
                    pollingCenter.pollingCenterNameOnCard,
                  ),
                ]),

                SizedBox(height: 3.h),

                // Map Button
                _buildMapButton(pollingCenter),
              ],
            ),
          );
        } else if (state is FetchProfileLoading) {
          return _buildLoadingPollingCenterSection();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2.5.w),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 6.w),
          SizedBox(height: 1.h),
          TextCustom(
            text: title,
            fontSize: 3.5,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          SizedBox(height: 0.5.h),
          TextCustom(
            text: value,
            fontSize: 4.5,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String sectionTitle, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextCustom(
          text: sectionTitle,
          fontSize: 4.5,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: 1.h),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: TextCustom(
              text: label,
              fontSize: 4,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).hintColor,
            ),
          ),
          Expanded(
            child: TextCustom(
              text: value,
              fontSize: 4,
              textAlign: TextAlign.start,
              maxLines: 3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPollingCenterSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(Iconsax.location, size: 5.w),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainerCustom(
                      height: 2.5,
                      width: 60,
                      borderRadius: 3.5,
                    ),
                    SizedBox(height: 0.5.h),
                    ShimmerContainerCustom(
                      height: 2,
                      width: 40,
                      borderRadius: 3.5,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Cards shimmer
          Row(
            children: [
              Expanded(
                child: ShimmerContainerCustom(
                  height: 12,
                  width: double.infinity,
                  borderRadius: 2.5,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ShimmerContainerCustom(
                  height: 12,
                  width: double.infinity,
                  borderRadius: 2.5,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Details shimmer
          ShimmerContainerCustom(height: 2, width: 40, borderRadius: 3.5),
          SizedBox(height: 1.h),
          ShimmerContainerCustom(
            height: 8,
            width: double.infinity,
            borderRadius: 2,
          ),
          SizedBox(height: 1.h),
          ShimmerContainerCustom(
            height: 8,
            width: double.infinity,
            borderRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(PollingCenterModel pollingCenter) {
    final hasCoordinates =
        pollingCenter.lat.isNotEmpty && pollingCenter.lng.isNotEmpty;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      child: Material(
        elevation: hasCoordinates ? 8 : 2,
        borderRadius: BorderRadius.circular(3.w),
        shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
        child: InkWell(
          onTap: hasCoordinates
              ? () async {
                  await launchUrl(
                    Uri.parse(
                      'http://maps.google.com/maps?q=${pollingCenter.lat},${pollingCenter.lng}&ll=${pollingCenter.lat},${pollingCenter.lng}&z=17',
                    ),
                    mode: LaunchMode.externalApplication,
                    webOnlyWindowName: "Polling Center",
                  );

                  // _openGoogleMaps(pollingCenter.lat, pollingCenter.lng);
                }
              : () => _showErrorMessage('الإحداثيات غير متوفرة لهذا المركز'),
          borderRadius: BorderRadius.circular(3.w),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 6.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasCoordinates
                    ? [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ]
                    : [Colors.grey, Colors.grey.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(Iconsax.map, color: Colors.white, size: 5.w),
                ),
                SizedBox(width: 3.w),
                TextCustom(
                  text: hasCoordinates
                      ? 'عرض على الخريطة'
                      : 'الإحداثيات غير متوفرة',
                  fontSize: 5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(String latitude, String longitude) async {
    try {
      print('=== Opening Map Debug Info ===');
      print('Latitude: "$latitude"');
      print('Longitude: "$longitude"');

      // Check if coordinates are valid
      if (latitude.isEmpty || longitude.isEmpty) {
        print('Error: Empty coordinates');
        _showErrorMessage('الإحداثيات غير متوفرة');
        return;
      }

      // Clean coordinates and validate
      final lat = latitude.trim();
      final lng = longitude.trim();

      // Try to parse as double to validate
      try {
        final latDouble = double.parse(lat);
        final lngDouble = double.parse(lng);
        print('Parsed coordinates: $latDouble, $lngDouble');
      } catch (e) {
        print('Error: Invalid coordinate format');
        _showErrorMessage('صيغة الإحداثيات غير صحيحة');
        return;
      }

      // List of URLs to try in order
      final urls = [
        // 1. Universal geo link (works on most devices)
        'geo:$lat,$lng?q=$lat,$lng',

        // 2. Google Maps app scheme
        'comgooglemaps://?center=$lat,$lng&zoom=16',

        // 3. Apple Maps (for iOS)
        'maps://?ll=$lat,$lng&q=مركز الاقتراع',

        // 4. Web version (always works)
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      ];

      for (int i = 0; i < urls.length; i++) {
        try {
          final url = Uri.parse(urls[i]);
          print('Trying URL ${i + 1}: $url');

          if (await canLaunchUrl(url)) {
            print('Success! Opening with URL ${i + 1}');
            await launchUrl(
              url,
              mode: i == urls.length - 1
                  ? LaunchMode.externalApplication
                  : LaunchMode.externalNonBrowserApplication,
            );
            return;
          } else {
            print('URL ${i + 1} not available');
          }
        } catch (e) {
          print('Error with URL ${i + 1}: $e');
          continue;
        }
      }

      // If all URLs failed
      _showErrorMessage('لا يمكن فتح أي تطبيق خرائط');
    } catch (e) {
      print('General error opening maps: $e');
      _showErrorMessage('حدث خطأ في فتح الخريطة: ${e.toString()}');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextCustom(text: message, color: Colors.white, fontSize: 4),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'حسناً',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
