import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/features/voter/models/voter_model.dart';

class PollingCenterCard extends StatelessWidget {
  final PollingCenterModel pollingCenter;
  final VoidCallback? onTap;

  const PollingCenterCard({super.key, required this.pollingCenter, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: Theme.of(context).hintColor.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and icon
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(Iconsax.location, color: Colors.red, size: 5.w),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        text: 'مركز الاقتراع',
                        fontSize: 4,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                      SizedBox(height: 0.5.h),
                      TextCustom(
                        text: pollingCenter.fullName,
                        fontSize: 5,
                        fontWeight: FontWeight.bold,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Information rows
            _buildInfoRow('العنوان:', pollingCenter.address),
            _buildInfoRow('الاسم الفعلي:', pollingCenter.actualName),
            _buildInfoRow('الرقم:', pollingCenter.number),
            _buildInfoRow(
              'عدد المحطات:',
              pollingCenter.stationCount.toString(),
            ),

            if (pollingCenter.code.isNotEmpty)
              _buildInfoRow('الكود:', pollingCenter.code),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Widget

  // _buildInfoRow(String label, String value) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 0.8.h),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 25.w,
  //           child: TextCustom(
  //             text: label,
  //             fontSize: 4,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.grey[600] ?? Colors.grey,
  //           ),
  //         ),
  //         Expanded(
  //           child: TextCustom(
  //             text: value,
  //             fontSize: 4,
  //             textAlign: TextAlign.start,
  //             maxLines: 3,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
