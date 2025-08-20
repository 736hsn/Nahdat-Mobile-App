import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageLocalCustom extends StatefulWidget {
  const ImageLocalCustom({
    required this.img,
    this.height,
    this.type = 'png',
    this.borderRadius = 0,
    this.width,
    this.color,
    this.alignment = FractionalOffset.center,
    this.fit = BoxFit.fitHeight,
    this.isFileImage = false,

    super.key,
  });
  final String img;
  final String type;
  final double? height;
  final double? width;
  final Color? color;
  final double borderRadius;
  final AlignmentGeometry alignment;
  final BoxFit fit;
  final bool isFileImage;

  @override
  State<ImageLocalCustom> createState() => _CustomImageLocalState();
}

class _CustomImageLocalState extends State<ImageLocalCustom> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius.sp),
      child: widget.isFileImage != true
          ? widget.type == "svg"
                ? SvgPicture.asset(
                    "assets/images/svg/${widget.img}.svg",
                    height: widget.height,
                    color: widget.color,
                    fit: widget.fit,
                    semanticsLabel: '',
                  )
                : Image.asset(
                    "assets/images/${widget.type}/${widget.img}.${widget.type}",
                    fit: widget.fit,
                    height: widget.height,
                    alignment: widget.alignment,
                    width: widget.width,
                  )
          : Image.file(
              File(widget.img),
              fit: widget.fit,
              height: widget.height?.h,
              alignment: widget.alignment,
              width: widget.width?.w,
            ),
    );
  }
}

class ImageAssetCustom extends StatefulWidget {
  const ImageAssetCustom({
    required this.img,
    this.height,
    this.type = 'png',
    this.borderRadius = 0,
    this.width,
    this.color,
    this.alignment = FractionalOffset.center,
    this.fit = BoxFit.fitHeight,
    super.key,
  });
  final String img;
  final String type;
  final double? height;
  final double? width;
  final Color? color;
  final double borderRadius;
  final AlignmentGeometry alignment;
  final BoxFit fit;
  @override
  State<ImageAssetCustom> createState() => _CustomImageAssetsState();
}

class _CustomImageAssetsState extends State<ImageAssetCustom> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: widget.type == "svg"
          ? SvgPicture.asset(
              "assets/images/svg/${widget.img}.svg",
              height: widget.height,
              color: widget.color,
              fit: widget.fit,
              semanticsLabel: '',
            )
          : Image.asset(
              "assets/images/${widget.type}/${widget.img}.${widget.type}",
              fit: widget.fit,
              height: widget.height,
              alignment: widget.alignment,
              width: widget.width,
            ),
    );
  }
}
