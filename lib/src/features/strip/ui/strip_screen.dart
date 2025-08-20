import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/shimmer_container.dart';

import 'package:supervisor/src/core/common/widgets/message_widget.dart';
import 'package:supervisor/src/core/common/widgets/chick_is_list_empty.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/features/strip/logic/strip/strip_cubit.dart';
import 'package:supervisor/src/features/strip/widgets/strip_card.dart';
import 'package:supervisor/src/features/strip/models/strip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:async';

class StripScreen extends StatefulWidget {
  const StripScreen({super.key});

  @override
  State<StripScreen> createState() => _StripScreenState();
}

class _StripScreenState extends State<StripScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final StripCubit _stripCubit = GetIt.instance<StripCubit>();
  Timer? _debounce;
  bool _isSearchMode = false;

  @override
  void initState() {
    super.initState();
    _loadStrips();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadStrips() async {
    await _stripCubit.fetchStrips(isRefresh: true);
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearchMode = false;
      });
      return;
    }

    setState(() {
      _isSearchMode = true;
    });
    _stripCubit.performSearch(query);
  }

  void _debouncedSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _performSearch(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchMode = false;
    });
    _stripCubit.clearSearch();
  }

  void _editStrip(StripModel strip) {
    context.push('/add-strip', extra: strip);
  }

  void _deleteStrip(StripModel strip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الشريط'),
        content: const Text('هل أنت متأكد من حذف هذا الشريط؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _stripCubit.deleteStrip(strip.id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBarCustom(title: 'شرائط الانتخاب'),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => context.push('/add-strip'),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   child: Icon(Iconsax.add, color: Colors.white),
      // ),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: _loadStrips,
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => context.push('/add-strip'),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    // width: 30,
                    // height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Iconsax.add, color: Colors.white),
                  ),
                ),
                Expanded(child: _buildSearchBar()),
              ],
            ),

            // Content
            Expanded(
              child: BlocConsumer<StripCubit, StripState>(
                bloc: _stripCubit,
                listener: (context, state) {
                  if (state is StripAddSuccess ||
                      state is StripUpdateSuccess ||
                      state is StripDeleteSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state is StripAddSuccess
                              ? state.message
                              : state is StripUpdateSuccess
                              ? state.message
                              : (state as StripDeleteSuccess).message,
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is StripAddError ||
                      state is StripUpdateError ||
                      state is StripDeleteError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state is StripAddError
                              ? state.message
                              : state is StripUpdateError
                              ? state.message
                              : (state as StripDeleteError).message,
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (_isSearchMode) {
                    return _buildSearchResults(state);
                  } else {
                    return _buildStripsList(state);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.search_normal_1,
            color: Theme.of(context).hintColor,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث في الشرائط...',
                hintTextDirection: TextDirection.rtl,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  color: Theme.of(context).hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onChanged: (value) {
                _debouncedSearch(value);
              },
              onSubmitted: (value) {
                _performSearch(value);
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: _clearSearch,
              child: Icon(
                Iconsax.close_circle,
                color: Theme.of(context).hintColor,
                size: 5.w,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStripsList(StripState state) {
    if (state is StripLoading) {
      return _buildLoadingState();
    } else if (state is StripError) {
      return MessageWidgetCustom(
        message: state.message,
        isIconVisible: true,
        iconData: Icons.error,
        iconColor: Colors.red,
        verticalPadding: 10,
      );
    } else if (state is StripLoaded) {
      return ChickIsEmptyList(
        isLoading: false,
        isEmpty: state.strips.isEmpty,
        message: 'لا توجد شرائط ',
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          itemCount: state.strips.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final strip = state.strips[index];
            return StripCard(
              strip: strip,
              onEdit: () => _editStrip(strip),
              onDelete: () => _deleteStrip(strip),
              onTap: () => _showStripDetails(strip),
            );
          },
        ),
      );
    }
    return _buildEmptyState();
  }

  Widget _buildSearchResults(StripState state) {
    if (state is StripSearchLoading) {
      return _buildLoadingState();
    } else if (state is StripSearchEmpty) {
      return _buildEmptySearchState();
    } else if (state is StripSearchNoResults) {
      return _buildNoResultsState();
    } else if (state is StripSearchError) {
      return MessageWidgetCustom(
        message: state.message,
        isIconVisible: true,
        iconData: Icons.error,
        iconColor: Colors.red,
        verticalPadding: 10,
      );
    } else if (state is StripSearchSuccess) {
      return ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: state.results.length,
        separatorBuilder: (context, index) => SizedBox(height: 1.h),
        itemBuilder: (context, index) {
          final result = state.results[index];
          return _buildSearchResultCard(result);
        },
      );
    }
    return _buildEmptySearchState();
  }

  Widget _buildSearchResultCard(SearchResult result) {
    return GestureDetector(
      onTap: () => context.push('/news-detail/${result.id}'),
      child: Container(
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.symmetric(vertical: 1.h),
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
        child: Row(
          children: [
            Icon(
              Iconsax.document_text_1,
              color: Theme.of(context).primaryColor,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: TextCustom(
                text: result.title,
                fontSize: 5,
                fontWeight: FontWeight.w600,
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
            ),
            Icon(
              Iconsax.arrow_left_2,
              color: Theme.of(context).hintColor,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.gallery,
            size: 20.w,
            color: Theme.of(context).hintColor.withOpacity(0.5),
          ),
          SizedBox(height: 3.h),
          TextCustom(
            text: "لا توجد شرائط ",
            fontSize: 6,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
          ),
          SizedBox(height: 1.h),
          TextCustom(
            text: "اضغط على زر + لإضافة شريط جديد",
            fontSize: 4,
            color: Theme.of(context).hintColor.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.search_normal_1,
            size: 15.w,
            color: Theme.of(context).hintColor,
          ),
          SizedBox(height: 2.h),
          TextCustom(
            text: "ابحث في الشرائط ",
            fontSize: 5,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.search_normal_1,
            size: 15.w,
            color: Theme.of(context).hintColor,
          ),
          SizedBox(height: 2.h),
          TextCustom(
            text: "لا توجد نتائج",
            fontSize: 5,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(
              color: Theme.of(context).hintColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header shimmer
              Row(
                children: [
                  ShimmerContainerCustom(
                    width: 10.w,
                    height: 10.w,
                    borderRadius: 2.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerContainerCustom(
                          width: 30.w,
                          height: 1.h,
                          borderRadius: 4,
                        ),
                        SizedBox(height: 1.h),
                        ShimmerContainerCustom(
                          width: 50.w,
                          height: 1.2.h,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              // Image shimmer
              ShimmerContainerCustom(
                width: double.infinity,
                height: 40.w,
                borderRadius: 3.w,
              ),
              SizedBox(height: 3.h),
              // Content shimmer
              ShimmerContainerCustom(
                width: double.infinity,
                height: 1.h,
                borderRadius: 4,
              ),
              SizedBox(height: 1.h),
              ShimmerContainerCustom(width: 70.w, height: 1.h, borderRadius: 4),
              SizedBox(height: 2.h),
              // Footer shimmer
              ShimmerContainerCustom(
                width: double.infinity,
                height: 1.h,
                borderRadius: 4,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStripDetails(StripModel strip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),

            // Strip card
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: StripCard(
                  strip: strip,
                  onEdit: () {
                    Navigator.pop(context);
                    _editStrip(strip);
                  },
                  onDelete: () {
                    Navigator.pop(context);
                    _deleteStrip(strip);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
