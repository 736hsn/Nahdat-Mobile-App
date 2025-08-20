import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';

import 'loading_indicator.dart';
import 'message_widget.dart';

class ListViewCustom<T> extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final List<T> items;
  final bool isLoading;
  final Widget Function()? loadingWidget;
  final Widget Function(String)? errorWidget;
  final Widget Function()? emptyWidget;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onRetry;
  final ScrollController? controller;

  // Shimmer loading properties
  final Widget? shimmerItemBuilder;
  final int shimmerItemCount;
  final bool useShimmerLoading;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;

  // OnEmpty & onError properties
  final String? errorMessage;
  final String? emptyMessage;
  final double? errorMessageSize;
  final double? emptyMessageSize;
  final Color? errorMessageColor;
  final Color? emptyMessageColor;
  final double onErrorAndOnEmptyVerticalPadding;
  final double onErrorAndOnEmptyHorizontalPadding;

  const ListViewCustom({
    super.key,
    required this.itemBuilder,
    required this.items,
    this.errorMessage,
    this.isLoading = false,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = true,
    this.physics,
    this.separatorBuilder,
    this.padding,
    this.onRetry,
    this.controller,
    this.shimmerItemBuilder,
    this.shimmerItemCount = 5,
    this.useShimmerLoading = false,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.onErrorAndOnEmptyVerticalPadding = 0,
    this.onErrorAndOnEmptyHorizontalPadding = 0,
    this.emptyMessage,
    this.errorMessageSize,
    this.emptyMessageSize,
    this.errorMessageColor,
    this.emptyMessageColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      if (useShimmerLoading && shimmerItemBuilder != null) {
        return _buildShimmerLoading();
      }
      return loadingWidget?.call() ?? _defaultLoadingWidget();
    }

    if (errorMessage != null) {
      return errorWidget?.call(errorMessage!) ??
          _defaultErrorWidget(errorMessage!, context);
    }

    if (items.isEmpty) {
      return emptyWidget?.call() ?? _defaultEmptyWidget(context);
    }

    return ListView.separated(
      padding: padding,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      controller: controller,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox(),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: padding,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: shimmerItemCount,
      itemBuilder: (_, __) => shimmerItemBuilder!,
      separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox(),
    );
  }

  Widget _defaultLoadingWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: onErrorAndOnEmptyVerticalPadding.h,
          horizontal: onErrorAndOnEmptyHorizontalPadding.w,
        ),
        child: LoadingCustom(),
      ),
    );
  }

  Widget _defaultErrorWidget(String error, BuildContext context) {
    return MessageWidgetCustom(
      message: error,
      messageSize: errorMessageSize,
      messageColor: errorMessageColor,
      verticalPadding: onErrorAndOnEmptyVerticalPadding,
      horizontalPadding: onErrorAndOnEmptyHorizontalPadding,
    );
  }

  Widget _defaultEmptyWidget(BuildContext context) {
    return MessageWidgetCustom(
      message: emptyMessage ?? 'لا توجد بيانات',
      messageSize: emptyMessageSize,
      messageColor: emptyMessageColor,
      verticalPadding: onErrorAndOnEmptyVerticalPadding,
      horizontalPadding: onErrorAndOnEmptyHorizontalPadding,
    );
  }
}
