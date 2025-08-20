import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/core/utils/generated/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/text.dart';
import 'button.dart';

class GenderSelectionBottomSheetCustom extends StatefulWidget {
  final Function(String) onGenderSelected;
  final String? initialSelection;

  const GenderSelectionBottomSheetCustom({
    super.key,
    required this.onGenderSelected,
    this.initialSelection,
  });

  @override
  State<GenderSelectionBottomSheetCustom> createState() =>
      _GenderSelectionBottomSheetCustomState();
}

class _GenderSelectionBottomSheetCustomState
    extends State<GenderSelectionBottomSheetCustom> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialSelection;
  }

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
          TextCustom(
            text: LocaleKeys.selectGender,
            fontSize: 6,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 3.h),
          _buildGenderOption(LocaleKeys.male1, context),
          SizedBox(height: 1.5.h),
          _buildGenderOption(LocaleKeys.female1, context),
          SizedBox(height: 3.h),
          Center(
            child: ButtonCustom(
              title: LocaleKeys.selectAndSave,
              width: 90.w,
              onTap: () {
                if (_selectedGender != null) {
                  widget.onGenderSelected(_selectedGender!);
                }
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, BuildContext context) {
    final isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
        widget.onGenderSelected(gender);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0.85.h, horizontal: 0.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(4.5.sp),
        ),
        child: Row(
          children: [
            // Radio button
            Radio<String>(
              value: gender,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
                widget.onGenderSelected(value!);
              },
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.4);
              }),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: TextCustom(
                text: gender,
                fontSize: 5.5,
                textAlign: TextAlign.start,
              ),
            ),
            // Check icon for selected option
            if (isSelected)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                  size: 6.w,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
