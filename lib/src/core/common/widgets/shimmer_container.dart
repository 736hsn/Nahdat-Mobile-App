import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainerCustom extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final BoxShape? shape;
  final Widget? child;
  final String type;
  const ShimmerContainerCustom({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.shape,
    this.child,
    this.type = 'default',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).canvasColor.withOpacity(0.8),
        highlightColor:
            type == 'default'
                ? Theme.of(context).hintColor.withOpacity(0.9)
                : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withOpacity(0.1),
            borderRadius:
                shape == BoxShape.circle
                    ? null
                    : BorderRadius.circular(borderRadius ?? 0),
          ),
          child: child,
        ),
      ),
    );
  }
}
