import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/icon_button.dart';
import '../widgets/text.dart';

class TitleWithShowMore extends StatelessWidget {
  final String title;
  final double? horizontalPadding;
  final dynamic Function() onTap;

  const TitleWithShowMore({
    super.key,
    required this.title,
    required this.onTap,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding?.w ?? 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextCustom(
            text: title,
            fontSize: 5.6,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
          IconButtonCustom(
            iconData: Iconsax.arrow_left,
            padding: EdgeInsets.symmetric(horizontal: 0.25.w, vertical: 0.25.w),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
