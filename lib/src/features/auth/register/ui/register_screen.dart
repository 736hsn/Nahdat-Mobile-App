import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisor/src/core/common/widgets/DialogCustom.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/text_form_field.dart';
import 'package:supervisor/src/core/common/widgets/theme_aware_logo.dart';
import 'package:supervisor/src/features/auth/register/logic/register_cubit.dart';
import 'package:supervisor/src/features/auth/register/logic/register_state.dart';
import '../../../../core/sizing/size_config.dart';
import '../../../../core/theme/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// Controllers for the new form fields
final TextEditingController _firstNameController = TextEditingController();
final TextEditingController _secondNameController = TextEditingController();
final TextEditingController _thirdNameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _yearOfBirthController = TextEditingController();
final TextEditingController _pollingCenterIdController =
    TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Variables for file handling and dropdown
File? _cardImage;
File? _imagePath;
String _isCardUpdated = '1';
final ImagePicker _picker = ImagePicker();

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    // context.read<GovernoratesCubit>().fetchGovernorates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return DialogCustom(
                  title: 'تم إنشاء الحساب بنجاح',
                  imagePath: 'success',
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                );
              },
            ).then((value) {
              if (mounted) {
                context.push('/login');
              }
            });
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Form(
            key: _formKey,
            child: Stack(
              children: [
                _buildEffect(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: ListView(
                    children: [
                      SizedBox(height: 8.h),
                      _buildWelcomeSection(),
                      SizedBox(height: 6.5.h),
                      _buildTextFieldsSection(state),
                      SizedBox(height: 10.h),
                      Center(child: _buildButtonsSection(state)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          // SizedBox(height: 6.h),
          TextCustom(
            text: 'انضم إلى عائلة نهضة العراق',
            fontWeight: FontWeight.bold,
            fontSize: 7,
          ),
          SizedBox(height: 1.2.h),
          TextCustom(
            text: 'انضم إلى عائلة نهضة العراق',
            fontWeight: FontWeight.w600,
            maxLines: 10,
            fontSize: 5.25,
          ),
        ],
      ),
    );
  }

  _buildTextFieldsSection(RegisterState state) {
    String? registerError;
    if (state is RegisterError) {
      registerError = state.error.tr();
    }
    return Column(
      children: [
        TextFormFieldCustom(
          hintText: 'الاسم الأول',
          controller: _firstNameController,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'الاسم الأول مطلوب';
            }
            return null;
          },
        ),
        SizedBox(height: 1.h),
        TextFormFieldCustom(
          hintText: 'الاسم الثاني',
          controller: _secondNameController,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'الاسم الثاني مطلوب';
            }
            return null;
          },
        ),
        SizedBox(height: 1.h),
        TextFormFieldCustom(
          hintText: 'الاسم الثالث',
          controller: _thirdNameController,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'الاسم الثالث مطلوب';
            }
            return null;
          },
        ),
        SizedBox(height: 1.h),

        TextFormFieldCustom(
          hintText: 'رقم الهاتف',
          controller: _phoneController,
          keyboardType: TextInputType.phone,

          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء أدخل رقم الهاتف';
            } else if ((value.startsWith('07') && value.length < 11) ||
                (!value.startsWith('7') && !value.startsWith('07')) ||
                value.length < 10 ||
                value.length > 11) {
              return 'الرجاء أدخل رقم هاتف صالح';
            }
            return null;
          },
        ),
        SizedBox(height: 1.h),
        // LeftAlignedTextFormField(
        //   controller: _phoneController,
        //   hintText: 'رقم الهاتف',
        //   prefixText: '',
        //   showRedStar: false,
        //   keyboardType: TextInputType.phone,
        //   errorText: registerError,
        //   validator: (String? value) {
        //     if (value == null || value.isEmpty) {
        //       return 'الرجاء أدخل رقم الهاتف';
        //     } else if ((value.startsWith('07') && value.length < 11) ||
        //         (!value.startsWith('7') && !value.startsWith('07')) ||
        //         value.length < 10 ||
        //         value.length > 11) {
        //       return 'الرجاء أدخل رقم هاتف صالح';
        //     }
        //     return null;
        //   },
        // ),
        // SizedBox(height: 1.h),
        TextFormFieldCustom(
          hintText: 'سنة الميلاد (اختياري)',
          controller: _yearOfBirthController,
          keyboardType: TextInputType.number,
        ),

        SizedBox(height: 1.h),
        TextFormFieldCustom(
          hintText: 'معرف مركز الاقتراع',
          controller: _pollingCenterIdController,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'معرف مركز الاقتراع مطلوب';
            }
            return null;
          },
        ),
        SizedBox(height: 1.h),
        _buildFilePickerField(
          title: 'صورة البطاقة',
          file: _cardImage,
          onTap: () => _pickCardImage(),
          isRequired: true,
        ),
        SizedBox(height: 1.h),
        _buildFilePickerField(
          title: 'صورة شخصية (اختياري)',
          file: _imagePath,
          onTap: () => _pickPersonalImage(),
          isRequired: false,
        ),
        SizedBox(height: 1.h),

        _buildDropdownField(),
      ],
    );
  }

  Widget _buildFilePickerField({
    required String title,
    required File? file,
    required VoidCallback onTap,
    required bool isRequired,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.2.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(3.5.w),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.3),
                ),
              ),
              child: file != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(2.w),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                        width: 12.w,
                        height: 12.w,
                      ),
                    )
                  : Icon(
                      Icons.upload_file,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 6.w,
                    ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: TextCustom(
                text: file != null ? 'تم اختيار الصورة' : title,
                color: file != null
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                fontSize: 5,
              ),
            ),
            if (isRequired)
              TextCustom(
                text: '*',
                color: Theme.of(context).colorScheme.error,
                fontSize: 6,
                fontWeight: FontWeight.w700,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.2.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(3.5.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextCustom(
            text: 'هل البطاقة محدثة؟',
            fontSize: 5.5,

            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          Switch(
            value: _isCardUpdated == '1',
            onChanged: (value) {
              setState(() {
                _isCardUpdated = value ? '1' : '0';
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
            activeTrackColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.3),
            inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(
              context,
            ).colorScheme.secondary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCardImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _cardImage = File(image.path);
      });
    }
  }

  Future<void> _pickPersonalImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = File(image.path);
      });
    }
  }

  _buildButtonsSection(RegisterState state) {
    return Row(
      children: [
        ButtonCustom(
          title: 'انشاء حساب',
          loading: state is RegisterLoading,
          width: 54,
          onTap: () {
            if (_formKey.currentState!.validate()) {
              if (_cardImage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('الرجاء اختيار صورة البطاقة')),
                );
                return;
              }

              context.read<RegisterCubit>().register(
                firstName: _firstNameController.text,
                secondName: _secondNameController.text,
                thirdName: _thirdNameController.text,
                phone: _phoneController.text,
                yearOfBirth: _yearOfBirthController.text.isEmpty
                    ? null
                    : _yearOfBirthController.text,
                cardImage: _cardImage!,
                imagePath: _imagePath,
                isCardUpdated: _isCardUpdated,
                pollingCenterId: _pollingCenterIdController.text,
              );
            }
          },
        ),
        SizedBox(width: 2.w),
        ButtonCustom(
          title: 'تسجيل الدخول',
          color: Theme.of(context).colorScheme.surface,
          textColor: Theme.of(context).colorScheme.primary,
          borderColor: Theme.of(context).colorScheme.primary,
          width: 34,
          onTap: () {
            context.push('/login');
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
