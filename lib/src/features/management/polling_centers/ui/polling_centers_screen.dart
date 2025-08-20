import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/chick_is_list_empty.dart';
import 'package:supervisor/src/core/common/widgets/loading_indicator.dart';
import 'package:supervisor/src/core/common/widgets/message_widget.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/text_form_field.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:supervisor/src/features/management/polling_centers/logic/polling_centers_cubit.dart';
import 'package:supervisor/src/features/voter/models/voter_model.dart';
import '../widgets/polling_center_card.dart';

class PollingCentersScreen extends StatefulWidget {
  const PollingCentersScreen({super.key});

  @override
  State<PollingCentersScreen> createState() => _PollingCentersScreenState();
}

class _PollingCentersScreenState extends State<PollingCentersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<PollingCentersCubit>().fetchPollingCenters(isRefresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarCustom(title: 'مراكز التصويت'),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: _loadData,
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              // padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              // decoration: BoxDecoration(
              //   color: Theme.of(context).cardColor,
              //   borderRadius: BorderRadius.circular(4.w),
              //   border: Border.all(
              //     color: Theme.of(context).hintColor.withOpacity(0.3),
              //   ),
              // ),
              child: Row(
                children: [
                  SizedBox(width: 3.w),
                  Expanded(
                    child: TextFormFieldCustom(
                      controller: _searchController,
                      hintText: 'ابحث عن مركز التصويت...',

                      onChanged: (value) {
                        context
                            .read<PollingCentersCubit>()
                            .filterPollingCenters(value);
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        context.read<PollingCentersCubit>().resetToAllCenters();
                      },
                      child: Icon(
                        Iconsax.close_circle,
                        color: Theme.of(context).hintColor,
                        size: 5.w,
                      ),
                    ),
                ],
              ),
            ),

            // Polling Centers List
            Expanded(
              child: BlocBuilder<PollingCentersCubit, PollingCentersState>(
                builder: (context, state) {
                  if (state is PollingCentersLoading) {
                    return const Center(child: LoadingCustom());
                  } else if (state is PollingCentersError) {
                    return MessageWidgetCustom(
                      message: state.error,
                      isIconVisible: true,
                      iconData: Icons.error,
                      iconColor: Colors.red,
                      verticalPadding: 10,
                    );
                  } else if (state is PollingCentersLoaded) {
                    final pollingCenters = state.pollingCenters;

                    return ChickIsEmptyList(
                      isLoading: false,
                      isEmpty: pollingCenters.isEmpty,
                      message: 'لا توجد مراكز اقتراع',
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        itemCount: pollingCenters.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                          final center = pollingCenters[index];
                          return PollingCenterCard(
                            pollingCenter: center,
                            onTap: () {
                              // يمكن إضافة تنقل لتفاصيل المركز إذا لزم الأمر
                              _showPollingCenterDetails(center);
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPollingCenterDetails(PollingCenterModel center) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              // Title
              TextCustom(
                text: 'تفاصيل مركز التصويت',
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 3.h),

              // Details
              _buildDetailRow('اسم المركز:', center.name),
              _buildDetailRow('العنوان:', center.address),
              _buildDetailRow('الاسم الفعلي:', center.actualName),
              _buildDetailRow('الرقم:', center.number),
              _buildDetailRow('عدد المحطات:', center.stationCount.toString()),
              _buildDetailRow('الكود:', center.code),

              SizedBox(height: 3.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: TextCustom(
              text: label,
              fontSize: 4.5,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).hintColor,
            ),
          ),
          Expanded(
            child: TextCustom(
              text: value,
              fontSize: 4.5,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
