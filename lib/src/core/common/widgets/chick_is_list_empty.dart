import 'package:flutter/material.dart';
import '../widgets/text.dart';

import 'loading_indicator.dart';

class ChickIsEmptyList extends StatelessWidget {
  const ChickIsEmptyList({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.child,
    this.message,
    this.verticalPadding,
  });

  final bool isLoading;
  final bool isEmpty;
  final String? message;
  final Widget child;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: LoadingCustom())
        : isEmpty
        ? Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 0),
            child: TextCustom(text: message ?? 'لا توجد بيانات', fontSize: 6),
          ),
        )
        : child;
  }
}
