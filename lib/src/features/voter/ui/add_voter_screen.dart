import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisor/src/core/common/widgets/DialogCustom.dart';
import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';

import 'package:supervisor/src/core/common/widgets/text.dart';

import 'package:supervisor/src/features/voter/logic/add_voter_cubit.dart';
import 'package:supervisor/src/features/voter/models/voter_model.dart';
import '../../../core/sizing/size_config.dart';

class AddVoterScreen extends StatefulWidget {
  const AddVoterScreen({super.key});

  @override
  State<AddVoterScreen> createState() => _AddVoterScreenState();
}

class _AddVoterScreenState extends State<AddVoterScreen>
    with TickerProviderStateMixin {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _thirdNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _yearOfBirthController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  File? _cardImage;
  File? _imagePath;
  String _isCardUpdated = '1';
  PollingCenterModel? _selectedPollingCenter;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<AddVoterCubit>().fetchPollingCenters();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddVoterCubit, AddVoterState>(
      listener: (context, state) {
        if (state is AddVoterSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return DialogCustom(
                  title: 'تم إضافة عضو بنجاح',
                  imagePath: 'success',
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                );
              },
            ).then((value) {
              if (mounted) {
                _clearForm();
                context.pop();
              }
            });
          });
        } else if (state is AddVoterError) {
          _showErrorSnackBar(state.error);
        } else if (state is PollingCentersError) {
          _showErrorSnackBar('فشل في تحميل مراكز الاقتراع: ${state.error}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBarCustom(title: 'إضافة العضر جديد'),
          body: Stack(
            children: [
              // _buildBackgroundEffect(),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              SizedBox(height: 3.h),
                              _buildHeaderSection(),
                              SizedBox(height: 3.h),
                              _buildPersonalInfoCard(state),
                              SizedBox(height: 2.h),
                              _buildPollingCenterCard(state),
                              SizedBox(height: 2.h),
                              _buildDocumentsCard(),
                              SizedBox(height: 2.h),
                              _buildCardStatusCard(),
                              SizedBox(height: 4.h),
                              _buildButtonsSection(state),
                              SizedBox(height: 6.h),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackgroundEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.02),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Icon(
              Icons.person_add_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  text: 'إضافة العضر جديد',
                  fontWeight: FontWeight.bold,
                  fontSize: 6.5,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                SizedBox(height: 0.5.h),
                TextCustom(
                  text: 'املأ جميع المعلومات المطلوبة لإضافة العضر جديد',
                  fontWeight: FontWeight.w400,
                  maxLines: 22,
                  textAlign: TextAlign.start,
                  fontSize: 4.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(AddVoterState state) {
    return _buildCard(
      title: 'المعلومات الشخصية',
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          _buildEnhancedTextField(
            controller: _firstNameController,
            hintText: 'الاسم الأول',
            icon: Iconsax.user,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الاسم الأول مطلوب';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          _buildEnhancedTextField(
            controller: _secondNameController,
            hintText: 'الاسم الثاني',
            icon: Iconsax.user,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الاسم الثاني مطلوب';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          _buildEnhancedTextField(
            controller: _thirdNameController,
            hintText: 'الاسم الثالث',
            icon: Iconsax.user,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الاسم الثالث مطلوب';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          _buildEnhancedTextField(
            controller: _phoneController,
            hintText: 'رقم الهاتف',
            icon: Iconsax.call,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'رقم الهاتف مطلوب';
              } else if ((value.startsWith('07') && value.length < 11) ||
                  (!value.startsWith('7') && !value.startsWith('07')) ||
                  value.length < 10 ||
                  value.length > 11) {
                return 'الرجاء إدخال رقم هاتف صالح';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          _buildEnhancedTextField(
            controller: _yearOfBirthController,
            hintText: 'سنة الميلاد (اختياري)',
            icon: Iconsax.calendar,
            keyboardType: TextInputType.number,
            isOptional: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPollingCenterCard(AddVoterState state) {
    return _buildCard(
      title: 'مركز الاقتراع',
      icon: Iconsax.building,
      child: _buildEnhancedPollingCenterDropdown(state),
    );
  }

  Widget _buildDocumentsCard() {
    return _buildCard(
      title: 'المستندات المطلوبة',
      icon: Iconsax.document,
      child: Column(
        children: [
          _buildEnhancedFilePickerField(
            title: 'صورة البطاقة',
            subtitle: 'اختر صورة واضحة للبطاقة',
            file: _cardImage,
            onTap: () => _pickCardImage(),
            isRequired: true,
            icon: Iconsax.card,
          ),
          SizedBox(height: 2.h),
          _buildEnhancedFilePickerField(
            title: 'صورة شخصية',
            subtitle: 'صورة شخصية واضحة (اختياري)',
            file: _imagePath,
            onTap: () => _pickPersonalImage(),
            isRequired: false,
            icon: Iconsax.camera,
          ),
        ],
      ),
    );
  }

  Widget _buildCardStatusCard() {
    return _buildCard(
      title: 'حالة البطاقة',
      icon: Iconsax.verify,
      child: _buildEnhancedCardStatusSwitch(),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              TextCustom(
                text: title,
                fontSize: 5.5,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          child,
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
  }) {
    final Locale locale = Localizations.localeOf(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          fontSize: 4.5.sp,

          fontFamily: locale != Locale('fa', 'IR') ? 'Cairo' : 'Nrt',
        ),
        prefixIcon: Container(
          margin: EdgeInsets.all(2.w),
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 5.w,
          ),
        ),
        suffixIcon: isOptional
            ? Container(
                margin: EdgeInsets.all(2.w),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: TextCustom(
                  text: 'اختياري',
                  fontSize: 3.5,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3.w),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3.w),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3.w),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3.w),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 4.5.sp,
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildEnhancedPollingCenterDropdown(AddVoterState state) {
    List<PollingCenterModel> availablePollingCenters = [];
    bool isPollingCentersLoading = false;
    bool hasPollingCentersError = false;

    // Determine polling centers based on state
    if (state is PollingCentersLoaded) {
      availablePollingCenters = state.pollingCenters;
    } else if (state is AddVoterLoading) {
      availablePollingCenters = state.pollingCenters;
    } else if (state is AddVoterError) {
      availablePollingCenters = state.pollingCenters;
    } else if (state is PollingCentersLoading) {
      isPollingCentersLoading = true;
    } else if (state is PollingCentersError) {
      hasPollingCentersError = true;
    }

    return GestureDetector(
      onTap: () {
        if (availablePollingCenters.isNotEmpty) {
          _showPollingCenterBottomSheet(availablePollingCenters);
        } else if (hasPollingCentersError) {
          context.read<AddVoterCubit>().fetchPollingCenters();
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: _selectedPollingCenter != null
                ? Theme.of(context).colorScheme.primary
                : hasPollingCentersError
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: _selectedPollingCenter != null || hasPollingCentersError
                ? 2
                : 1,
          ),
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Icon(
                Iconsax.building,
                color: Theme.of(context).colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    text: _selectedPollingCenter != null
                        ? _selectedPollingCenter!.pollingCenterNameOnCard
                        : isPollingCentersLoading
                        ? 'جاري تحميل مراكز الاقتراع...'
                        : hasPollingCentersError
                        ? 'خطأ في تحميل مراكز الاقتراع'
                        : availablePollingCenters.isEmpty
                        ? 'لا توجد مراكز اقتراع متاحة'
                        : 'اختر مركز الاقتراع',
                    fontSize: 4.5,
                    maxLines: 4,
                    textAlign: TextAlign.start,
                    fontWeight: _selectedPollingCenter != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: _selectedPollingCenter != null
                        ? Theme.of(context).colorScheme.onSurface
                        : hasPollingCentersError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  if (_selectedPollingCenter != null) ...[
                    SizedBox(height: 0.5.h),
                    TextCustom(
                      text: _selectedPollingCenter!.address,
                      fontSize: 3.5,
                      isSubTitle: true,
                      maxLines: 2,
                    ),
                  ],
                  if (hasPollingCentersError) ...[
                    SizedBox(height: 0.5.h),
                    TextCustom(
                      text: 'اضغط للمحاولة مرة أخرى',
                      fontSize: 3.5,
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.7),
                    ),
                  ],
                ],
              ),
            ),
            if (isPollingCentersLoading)
              SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            else
              Icon(
                hasPollingCentersError
                    ? Iconsax.refresh
                    : availablePollingCenters.isNotEmpty
                    ? Iconsax.arrow_down
                    : Iconsax.warning_2,
                color: hasPollingCentersError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
          ],
        ),
      ),
    );
  }

  void _showPollingCenterBottomSheet(List<PollingCenterModel> pollingCenters) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          TextEditingController searchController = TextEditingController();
          List<PollingCenterModel> filteredCenters = pollingCenters;

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.w),
                topRight: Radius.circular(6.w),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 12.w,
                    height: 0.5.h,
                    margin: EdgeInsets.only(top: 2.h),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                ),

                // Header
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.building,
                        color: Theme.of(context).colorScheme.primary,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: TextCustom(
                          text: 'اختر مركز الاقتراع',
                          fontSize: 5.5,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Iconsax.close_circle,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 1.h),
                // Results count
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextCustom(
                      text: '${filteredCenters.length} مركز اقتراع',
                      fontSize: 4,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Polling centers list
                Expanded(
                  child: filteredCenters.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 15.w,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.3),
                              ),
                              SizedBox(height: 2.h),
                              TextCustom(
                                text: 'لا توجد مراكز اقتراع مطابقة للبحث',
                                fontSize: 4.5,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredCenters.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 2.h),
                          itemBuilder: (context, index) {
                            final center = filteredCenters[index];
                            final isSelected =
                                _selectedPollingCenter?.id == center.id;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPollingCenter = center;
                                });
                                Navigator.pop(context);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.1)
                                      : Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline
                                              .withOpacity(0.2),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(3.w),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.2)
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          2.w,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.location_on_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        size: 5.w,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            text:
                                                center.pollingCenterNameOnCard,
                                            fontSize: 4.5,
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.w600,
                                            // color: isSelected
                                            //     ? Theme.of(
                                            //         context,
                                            //       ).colorScheme.primary
                                            //     : Theme.of(
                                            //         context,
                                            //       ).colorScheme.onSurface,
                                            maxLines: 2,
                                          ),
                                          SizedBox(height: 0.5.h),
                                          TextCustom(
                                            text: center.address,
                                            fontSize: 3.5,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.7),
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        padding: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            2.w,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          size: 4.w,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedFilePickerField({
    required String title,
    required String subtitle,
    required File? file,
    required VoidCallback onTap,
    required bool isRequired,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: file != null
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: file != null
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: file != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.w),
                color: file != null
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: file != null
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: file != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(3.w),
                      child: Image.file(file, fit: BoxFit.cover),
                    )
                  : Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 6.w,
                    ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextCustom(
                          text: file != null ? 'تم اختيار الصورة' : title,
                          color: file != null
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          fontSize: 4.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isRequired)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.w,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          child: TextCustom(
                            text: 'مطلوب',
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 3.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  TextCustom(
                    text: subtitle,
                    fontSize: 3.5,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            Icon(
              file != null
                  ? Icons.check_circle_rounded
                  : Icons.cloud_upload_rounded,
              color: file != null
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              size: 6.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedCardStatusSwitch() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 5.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  text: 'هل البطاقة محدثة؟',
                  fontSize: 4.5,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                SizedBox(height: 0.5.h),
                TextCustom(
                  text: _isCardUpdated == '1'
                      ? 'نعم، البطاقة محدثة'
                      : 'لا، البطاقة غير محدثة',
                  fontSize: 3.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ],
            ),
          ),
          AnimatedScale(
            scale: _isCardUpdated == '1' ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Switch(
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
              inactiveThumbColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.5),
              inactiveTrackColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsSection(AddVoterState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonCustom(
          title: 'إضافة عضو',
          width: 54,
          loading: state is AddVoterLoading,
          onTap: () {
            if (_isFormValid() && state is! AddVoterLoading) {
              _submitForm();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: TextCustom(
                    text: 'يوجد خطأ في البيانات',
                    fontSize: 4.5,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            }
          },
        ),
        SizedBox(width: 2.w),
        ButtonCustom(
          title: 'الغاء',
          color: Theme.of(context).colorScheme.surface,
          textColor: Theme.of(context).colorScheme.primary,
          borderColor: Theme.of(context).colorScheme.primary,
          width: 34,
          onTap: () {
            context.pop();
          },
        ),
      ],
    );
  }

  // Widget _buildActionButtons(AddVoterState state) {
  //   return Container(
  //     padding: EdgeInsets.all(4.w),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).colorScheme.surface,
  //       borderRadius: BorderRadius.circular(4.w),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
  //           blurRadius: 20,
  //           offset: const Offset(0, -4),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 2,
  //           child: AnimatedContainer(
  //             duration: const Duration(milliseconds: 300),
  //             height: 12.h,
  //             child: ElevatedButton(
  //               onPressed: _isFormValid() && state is! AddVoterLoading
  //                   ? () => _submitForm()
  //                   : null,
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: _isFormValid() && state is! AddVoterLoading
  //                     ? Theme.of(context).colorScheme.primary
  //                     : Theme.of(
  //                         context,
  //                       ).colorScheme.onSurface.withOpacity(0.3),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(3.w),
  //                 ),
  //                 elevation: _isFormValid() && state is! AddVoterLoading
  //                     ? 4
  //                     : 0,
  //               ),
  //               child: state is AddVoterLoading
  //                   ? SizedBox(
  //                       width: 6.w,
  //                       height: 6.w,
  //                       child: CircularProgressIndicator(
  //                         strokeWidth: 2,
  //                         color: Theme.of(context).colorScheme.onPrimary,
  //                       ),
  //                     )
  //                   : Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Icon(
  //                           Icons.add_rounded,
  //                           color: Theme.of(context).colorScheme.onPrimary,
  //                           size: 5.w,
  //                         ),
  //                         SizedBox(width: 2.w),
  //                         TextCustom(
  //                           text: 'إضافة الناخب',
  //                           fontSize: 4.5,
  //                           fontWeight: FontWeight.w600,
  //                           color: Theme.of(context).colorScheme.onPrimary,
  //                         ),
  //                       ],
  //                     ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: 4.w),
  //         Expanded(
  //           child: SizedBox(
  //             height: 12.h,
  //             child: OutlinedButton(
  //               onPressed: () => context.pop(),
  //               style: OutlinedButton.styleFrom(
  //                 backgroundColor: Theme.of(context).colorScheme.surface,
  //                 side: BorderSide(
  //                   color: Theme.of(
  //                     context,
  //                   ).colorScheme.outline.withOpacity(0.3),
  //                 ),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(3.w),
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.close_rounded,
  //                     color: Theme.of(context).colorScheme.onSurface,
  //                     size: 5.w,
  //                   ),
  //                   SizedBox(width: 2.w),
  //                   TextCustom(
  //                     text: 'إلغاء',
  //                     fontSize: 4.5,
  //                     fontWeight: FontWeight.w600,
  //                     color: Theme.of(context).colorScheme.onSurface,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Theme.of(context).colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: TextCustom(
                text: message,
                fontSize: 4,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  Future<void> _pickCardImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _cardImage = File(image.path);
      });
    }
  }

  Future<void> _pickPersonalImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _imagePath = File(image.path);
      });
    }
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true &&
        _cardImage != null &&
        _selectedPollingCenter != null;
  }

  void _submitForm() {
    if (!_isFormValid()) {
      if (_cardImage == null) {
        _showErrorSnackBar('الرجاء اختيار صورة البطاقة');
        return;
      }
      if (_selectedPollingCenter == null) {
        _showErrorSnackBar('الرجاء اختيار مركز الاقتراع');
        return;
      }
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    context.read<AddVoterCubit>().createVoter(
      firstName: _firstNameController.text.trim(),
      secondName: _secondNameController.text.trim(),
      thirdName: _thirdNameController.text.trim(),
      phone: _phoneController.text.trim(),
      yearOfBirth: _yearOfBirthController.text.trim().isEmpty
          ? null
          : _yearOfBirthController.text.trim(),
      cardImage: _cardImage!,
      imagePath: _imagePath,
      isCardUpdated: _isCardUpdated,
      pollingCenterId: _selectedPollingCenter!.id.toString(),
    );
  }

  void _clearForm() {
    _firstNameController.clear();
    _secondNameController.clear();
    _thirdNameController.clear();
    _phoneController.clear();
    _yearOfBirthController.clear();
    setState(() {
      _cardImage = null;
      _imagePath = null;
      _selectedPollingCenter = null;
      _isCardUpdated = '1';
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _thirdNameController.dispose();
    _phoneController.dispose();
    _yearOfBirthController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
