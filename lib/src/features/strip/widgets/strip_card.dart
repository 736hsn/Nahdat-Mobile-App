import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/image_network.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/features/strip/models/strip_model.dart';

class StripCard extends StatefulWidget {
  final StripModel strip;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StripCard({
    super.key,
    required this.strip,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<StripCard> createState() => _StripCardState();
}

class _StripCardState extends State<StripCard> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: Theme.of(context).hintColor.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            _buildHeader(),

            // Image slider
            if (widget.strip.images.isNotEmpty) _buildImageSlider(),

            // Content
            _buildContent(),

            // Footer with polling center info
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          // Strip icon
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Icon(
              Iconsax.gallery,
              color: Theme.of(context).primaryColor,
              size: 5.w,
            ),
          ),

          SizedBox(width: 3.w),

          // Title
          Expanded(
            child: TextCustom(
              text: 'الشريط',
              fontSize: 5,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.onEdit != null)
                _buildActionButton(
                  icon: Iconsax.edit_2,
                  color: Colors.blue,
                  onTap: widget.onEdit!,
                ),
              if (widget.onDelete != null)
                _buildActionButton(
                  icon: Iconsax.trash,
                  color: Colors.red,
                  onTap: widget.onDelete!,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 2.w),
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(1.5.w),
        ),
        child: Icon(icon, color: color, size: 4.w),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Container(
      height: 50.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.w),
        child: Stack(
          children: [
            // PageView for image slider
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: widget.strip.images.length,
              itemBuilder: (context, index) {
                return ImageNetworkCustom(
                  url: widget.strip.images[index],
                  width: double.infinity,
                  height: 50.w,
                  fit: BoxFit.cover,
                );
              },
            ),

            // Custom indicators
            if (widget.strip.images.length > 1)
              Positioned(
                bottom: 3.w,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.strip.images.length,
                    (index) => Container(
                      width: _currentImageIndex == index ? 8.w : 2.w,
                      height: 1.w,
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      decoration: BoxDecoration(
                        color: _currentImageIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                    ),
                  ),
                ),
              ),

            // Navigation arrows
            if (widget.strip.images.length > 1) ...[
              Positioned(
                right: 2.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentImageIndex > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Iconsax.arrow_right_3,
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 2.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentImageIndex < widget.strip.images.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Iconsax.arrow_left_3,
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image count
          Row(
            children: [
              Icon(
                Iconsax.gallery,
                size: 4.w,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 2.w),
              TextCustom(
                text: '${widget.strip.images.length} صورة',
                fontSize: 4,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4.w),
          bottomRight: Radius.circular(4.w),
        ),
      ),
      child: Row(
        children: [
          // Polling center icon
          Icon(Iconsax.location, size: 4.w, color: Colors.red),
          SizedBox(width: 2.w),

          // Polling center info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  text: 'مركز الاقتراع',
                  fontSize: 3.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
                TextCustom(
                  text: widget.strip.pollingCenter.name,
                  fontSize: 4,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),

          // Created date
          TextCustom(
            text: _formatDate(widget.strip.createdAt),
            fontSize: 3.5,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
