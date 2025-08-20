import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/button.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/image_network.dart';
import 'package:supervisor/src/core/common/widgets/loading_indicator.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/features/strip/logic/strip/strip_cubit.dart';
import 'package:supervisor/src/features/strip/models/strip_model.dart';
import 'package:supervisor/src/features/management/polling_centers/logic/polling_centers_cubit.dart';
import 'package:supervisor/src/features/voter/models/voter_model.dart';

class AddStripScreen extends StatefulWidget {
  final StripModel? stripToEdit;

  const AddStripScreen({super.key, this.stripToEdit});

  @override
  State<AddStripScreen> createState() => _AddStripScreenState();
}

class _AddStripScreenState extends State<AddStripScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final List<File> _selectedImages = [];
  PollingCenterModel? _selectedPollingCenter;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool get _isEditing => widget.stripToEdit != null;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadPollingCenters();
    _initializeEditMode();
  }

  void _initializeAnimations() {
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

  void _loadPollingCenters() {
    context.read<PollingCentersCubit>().fetchPollingCenters(isRefresh: true);
  }

  void _initializeEditMode() {
    if (_isEditing) {
      _selectedPollingCenter = widget.stripToEdit!.pollingCenter;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarCustom(
        title: _isEditing ? 'تعديل الشريط' : 'إضافة شريط جديد',
      ),
      body: BlocConsumer<StripCubit, StripState>(
        listener: (context, state) {
          if (state is StripAddSuccess || state is StripUpdateSuccess) {
            _showSuccessMessage(
              _isEditing ? 'تم تحديث الشريط بنجاح' : 'تم إضافة الشريط بنجاح',
            );
            context.pop();
          } else if (state is StripAddError || state is StripUpdateError) {
            _showErrorMessage(
              state is StripAddError
                  ? state.message
                  : (state as StripUpdateError).message,
            );
          }
        },
        builder: (context, state) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderCard(),
                            SizedBox(height: 3.h),
                            _buildPollingCenterCard(),
                            SizedBox(height: 3.h),
                            _buildImagesCard(),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ),
                    _buildSubmitButton(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Icon(Iconsax.gallery, color: Colors.white, size: 8.w),
          ),
          SizedBox(height: 2.h),
          TextCustom(
            text: _isEditing ? 'تعديل الشريط ' : 'إضافة شريط = جديد',
            fontSize: 6,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          SizedBox(height: 1.h),
          TextCustom(
            text: _isEditing
                ? 'قم بتعديل معلومات الشريط '
                : 'أضف شريط جديد مع الصور ومركز الاقتراع',
            fontSize: 4,
            color: Colors.white.withOpacity(0.9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
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
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              TextCustom(
                text: title,
                fontSize: 5.5,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          child,
        ],
      ),
    );
  }

  Widget _buildPollingCenterCard() {
    return _buildCard(
      title: 'مركز الاقتراع',
      icon: Iconsax.location,
      child: Column(
        children: [
          BlocBuilder<PollingCentersCubit, PollingCentersState>(
            builder: (context, state) {
              if (state is PollingCentersLoading) {
                return _buildPollingCenterLoadingField();
              } else if (state is PollingCentersError) {
                return _buildPollingCenterErrorField(state.error);
              } else if (state is PollingCentersLoaded) {
                return _buildPollingCenterSelector(state.pollingCenters);
              }
              return _buildPollingCenterLoadingField();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPollingCenterSelector(List<PollingCenterModel> centers) {
    final errorColor = Theme.of(context).colorScheme.error;

    return GestureDetector(
      onTap: () => _showPollingCenterBottomSheet(centers),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: _selectedPollingCenter == null
                ? errorColor
                : Theme.of(context).hintColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3.5.w),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: _selectedPollingCenter == null
                    ? errorColor.withOpacity(0.1)
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Icon(
                Iconsax.building,
                color: _selectedPollingCenter == null
                    ? errorColor
                    : Theme.of(context).primaryColor,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    text: _selectedPollingCenter == null
                        ? 'اختر مركز الاقتراع *'
                        : _selectedPollingCenter!.pollingCenterNameOnCard,
                    fontSize: 5,
                    color: _selectedPollingCenter == null
                        ? errorColor
                        : Theme.of(context).canvasColor,
                    fontWeight: FontWeight.w500,
                  ),
                  if (_selectedPollingCenter != null) ...[
                    SizedBox(height: 0.5.h),
                    TextCustom(
                      text: _selectedPollingCenter!.address,
                      fontSize: 4,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      color: _selectedPollingCenter == null
                          ? errorColor
                          : Theme.of(context).hintColor,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Iconsax.arrow_down_1,
              color: Theme.of(context).hintColor,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollingCenterLoadingField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(3.5.w),
      ),
      child: Row(
        children: [
          const LoadingCustom(),
          SizedBox(width: 3.w),
          TextCustom(
            text: 'جاري تحميل مراكز الاقتراع...',
            fontSize: 4,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPollingCenterErrorField(String error) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: errorColor.withOpacity(0.1),
        border: Border.all(color: errorColor),
        borderRadius: BorderRadius.circular(3.5.w),
      ),
      child: Row(
        children: [
          Icon(Iconsax.warning_2, color: errorColor, size: 5.w),
          SizedBox(width: 3.w),
          Expanded(
            child: TextCustom(
              text: error,
              fontSize: 4,
              color: errorColor,
              textAlign: TextAlign.start,
            ),
          ),
          TextButton(
            onPressed: _loadPollingCenters,
            child: TextCustom(
              text: 'إعادة المحاولة',
              fontSize: 3.5,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesCard() {
    return _buildCard(
      title: 'صور الشريط',
      icon: Iconsax.gallery,
      child: Column(
        children: [
          if (_selectedImages.isEmpty && !_isEditing) _buildAddImagesPrompt(),
          if (_selectedImages.isNotEmpty || _isEditing) _buildImagesList(),
          SizedBox(height: 3.h),
          _buildImageActions(),
        ],
      ),
    );
  }

  Widget _buildAddImagesPrompt() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.gallery,
            color: Theme.of(context).primaryColor,
            size: 10.w,
          ),
          SizedBox(height: 2.h),
          TextCustom(
            text: 'أضف صور الشريط ',
            fontSize: 5,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 1.h),
          TextCustom(
            text: 'يمكنك إضافة عدة صور للشريط من الكاميرا أو المعرض',
            fontSize: 4,
            color: Theme.of(context).hintColor,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildImagesList() {
    final allImages = [
      ..._selectedImages.map((file) => {'type': 'file', 'data': file}),
      if (_isEditing)
        ...widget.stripToEdit!.images.map(
          (url) => {'type': 'url', 'data': url},
        ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.2,
      ),
      itemCount: allImages.length,
      itemBuilder: (context, index) {
        final image = allImages[index];
        return _buildImageItem(image, index);
      },
    );
  }

  Widget _buildImageItem(Map<String, dynamic> image, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.w),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).cardColor,
              child: image['type'] == 'file'
                  ? Image.file(image['data'], fit: BoxFit.cover)
                  : ImageNetworkCustom(url: image['data'], fit: BoxFit.cover),
            ),
            Positioned(
              top: 2.w,
              right: 2.w,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Iconsax.trash, color: Colors.white, size: 4.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageActions() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _pickImageFromCamera,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Iconsax.camera,
                    color: Theme.of(context).primaryColor,
                    size: 6.w,
                  ),
                  SizedBox(height: 1.h),
                  TextCustom(
                    text: 'الكاميرا',
                    fontSize: 4,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: GestureDetector(
            onTap: _pickImagesFromGallery,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Iconsax.gallery,
                    color: Theme.of(context).primaryColor,
                    size: 6.w,
                  ),
                  SizedBox(height: 1.h),
                  TextCustom(
                    text: 'المعرض',
                    fontSize: 4,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(StripState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ButtonCustom(
        title: _isEditing ? 'تحديث الشريط' : 'إضافة الشريط',
        loading:
            state is StripAddLoading ||
            state is StripUpdateLoading ||
            state is StripDeleteLoading,
        onTap: _submitForm,
      ),
    );
  }

  void _showPollingCenterBottomSheet(List<PollingCenterModel> centers) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.w),
            topRight: Radius.circular(5.w),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 15.w,
              height: 1.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Icon(Iconsax.location, color: Colors.red, size: 6.w),
                  SizedBox(width: 3.w),
                  TextCustom(
                    text: 'اختر مركز الاقتراع',
                    fontSize: 6,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Centers list
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: centers.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  final center = centers[index];
                  final isSelected = _selectedPollingCenter?.id == center.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPollingCenter = center;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Theme.of(context).cardColor,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).hintColor.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Icon(
                              Iconsax.location,
                              color: isSelected ? Colors.white : Colors.red,
                              size: 4.w,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustom(
                                  text: center.pollingCenterNameOnCard,
                                  fontSize: 4.5,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(height: 0.5.h),
                                TextCustom(
                                  text: center.address,
                                  fontSize: 3.5,
                                  color: Theme.of(context).hintColor,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Iconsax.tick_circle,
                              color: Theme.of(context).primaryColor,
                              size: 5.w,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      _showErrorMessage('فشل في التقاط الصورة: $e');
    }
  }

  Future<void> _pickImagesFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
        });
      }
    } catch (e) {
      _showErrorMessage('فشل في اختيار الصور: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (index < _selectedImages.length) {
        _selectedImages.removeAt(index);
      }
    });
  }

  void _submitForm() {
    if (_selectedPollingCenter == null) {
      _showErrorMessage('يرجى اختيار مركز الاقتراع');
      return;
    }

    if (_selectedImages.isEmpty && !_isEditing) {
      _showErrorMessage('يرجى إضافة صورة واحدة على الأقل');
      return;
    }

    final stripCubit = context.read<StripCubit>();

    if (_isEditing) {
      stripCubit.updateStrip(
        id: widget.stripToEdit!.id,
        pollingCenterId: _selectedPollingCenter!.id,
        newImages: _selectedImages.isNotEmpty ? _selectedImages : null,
      );
    } else {
      stripCubit.addStrip(
        pollingCenterId: _selectedPollingCenter!.id,
        images: _selectedImages,
      );
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.tick_circle, color: Colors.white, size: 5.w),
            SizedBox(width: 3.w),
            Expanded(
              child: TextCustom(
                text: message,
                fontSize: 4,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.warning_2, color: Colors.white, size: 5.w),
            SizedBox(width: 3.w),
            Expanded(
              child: TextCustom(
                text: message,
                fontSize: 4,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }
}
