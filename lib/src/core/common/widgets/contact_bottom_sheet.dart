import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';

import '../../utils/functions/functions.dart';
import '../widgets/text.dart';
import 'button.dart';
import 'image_assets.dart';

class ContactBottomSheetCustom extends StatelessWidget {
  final String title;
  final String? message;
  final String number;
  final bool phoneVisible;
  final bool whatsappVisible;

  const ContactBottomSheetCustom({
    super.key,
    required this.title,
    this.message,
    required this.number,
    this.phoneVisible = true,
    this.whatsappVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.only(right: 5.w, left: 5.w, top: 3.h, bottom: 3.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(text: title, fontSize: 6, fontWeight: FontWeight.w600),
          SizedBox(height: message != null ? 1.5.h : 2.h),
          if (message != null)
            TextCustom(
              text: message ?? '',
              textAlign: TextAlign.start,
              fontSize: 5.5,
              maxLines: 4,
              fontWeight: FontWeight.w500,
            ),
          if (message != null) SizedBox(height: 2.h),
          Row(
            children: [
              if (phoneVisible)
                Expanded(
                  child: ButtonCustom(
                    onTap: () => launchPhone(number),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageAssetCustom(
                          img: 'call',
                          type: 'svg',
                          height: 2.5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 1.h,
                            horizontal: 2.w,
                          ),
                          child: TextCustom(
                            text: 'هاتف',
                            height: 1,
                            color: Colors.white,
                            fontSize: 5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (phoneVisible && whatsappVisible) SizedBox(width: 1.h),
              if (whatsappVisible)
                Expanded(
                  child: ButtonCustom(
                    color: Theme.of(context).colorScheme.tertiary,
                    onTap: () => launchWhatsApp(number),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageAssetCustom(
                          img: 'whatsapp',
                          type: 'svg',
                          height: 2.5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 1.h,
                            horizontal: 2.w,
                          ),
                          child: TextCustom(
                            text: 'واتساب',
                            height: 1,
                            color: Colors.white,
                            fontSize: 5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.5.h),
        ],
      ),
    );
  }
}
