import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/src/core/theme/theme_cubit.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';

class ThemeAwareLogo extends StatelessWidget {
  const ThemeAwareLogo({
    super.key,
    this.height,
    this.width,
    this.type = 'png',
    this.borderRadius = 0,
    this.color,
    this.alignment = FractionalOffset.center,
    this.fit = BoxFit.fitHeight,
  });

  final double? height;
  final double? width;
  final String type;
  final double borderRadius;
  final Color? color;
  final AlignmentGeometry alignment;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        // Determine current brightness
        final brightness = Theme.of(context).brightness;
        final isDarkMode =
            themeState.themeMode == ThemeMode.dark ||
            (themeState.themeMode == ThemeMode.system &&
                brightness == Brightness.dark);

        // Use logo for dark mode, logo2 for light mode
        final logoName = isDarkMode ? 'logo' : 'logo2';

        return ImageAssetCustom(
          img: logoName,
          height: height,
          width: width,
          type: 'png',
          borderRadius: borderRadius,
          color: color,
          alignment: alignment,
          fit: fit,
        );
      },
    );
  }
}
