import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';

class LoadingCustom extends StatelessWidget {
  const LoadingCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 1.1.w, // Adjust the thickness of the circle
      backgroundColor: Colors.grey.withValues(
        alpha: 0.2,
      ), // Grey background circle
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}
