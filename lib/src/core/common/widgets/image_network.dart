import 'package:cached_network_image/cached_network_image.dart';
import 'package:supervisor/src/core/common/widgets/shimmer_container.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ImageNetworkCustom extends StatelessWidget {
  const ImageNetworkCustom({
    required this.url,
    this.radius = 15,
    this.height,
    this.width,
    this.onEmptyIconSize = 2.5,
    this.onEmptyIconData,
    this.fit = BoxFit.cover,
    super.key,
    this.errorColor,
    this.backgroundColor,
  });
  final String url;
  final double radius;
  final double? height;
  final double? width;
  final double onEmptyIconSize;
  final IconData? onEmptyIconData;
  final Color? backgroundColor;
  final Color? errorColor;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child:
            url != ''
                ? CachedNetworkImage(
                  imageUrl: url,
                  imageBuilder:
                      (context, imageProvider) => Container(
                        height: height?.h,
                        width: width?.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: fit,
                          ),
                        ),
                      ),
                  placeholder:
                      (context, url) => ShimmerContainerCustom(
                        height: height,
                        width: width,
                        borderRadius: radius,
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color:
                            backgroundColor ??
                            Theme.of(context).scaffoldBackgroundColor,
                        height: height?.h,
                        width: width?.w,
                        padding: EdgeInsets.all(1.h),
                        child: Icon(Iconsax.info_circle),
                      ),
                )
                : Container(
                  color:
                      backgroundColor ??
                      Theme.of(context).scaffoldBackgroundColor,
                  height: height?.h,
                  width: width?.w,
                  padding: EdgeInsets.all(1.h),
                  child: Icon(
                    onEmptyIconData ?? Iconsax.info_circle,
                    size: onEmptyIconSize.h,
                  ),
                ),
      );
    } catch (e) {
      return Container(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        height: height?.h,
        width: width?.w,
        padding: EdgeInsets.all(1.h),
        child: Icon(Iconsax.info_circle),
      );
    }
  }
}
