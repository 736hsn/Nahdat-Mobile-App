import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/sizing/size_config.dart';
import '../logic/voter_cubit.dart';
import '../models/voter_model.dart';
import '../../../core/services/voter_service.dart';
import '../../../core/common/widgets/loading_indicator.dart';
import '../../../core/common/widgets/message_widget.dart';
import '../logic/add_voter_cubit.dart';
import 'add_voter_screen.dart';
import '../../../core/di/dependency_injection.dart';
import 'widgets/voter_card.dart';
import 'widgets/voter_details_bottom_sheet.dart';
import 'widgets/voter_statistics_bottom_sheet.dart';

class VoterScreen extends StatefulWidget {
  const VoterScreen({super.key});

  @override
  State<VoterScreen> createState() => _VoterScreenState();
}

class _VoterScreenState extends State<VoterScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  void _debouncedSearch(String value) {
    if (_debounce != null) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // _performSearch(value);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<VoterCubit>().loadMoreVoters();
      }
    });
  }

  Future<void> _loadData() async {
    context.read<VoterCubit>().fetchVoters(isRefresh: true);
  }

  void _navigateToAddVoter() {
    // context.push('/add-voter');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<AddVoterCubit>(
          create: (context) => getIt<AddVoterCubit>(),
          child: const AddVoterScreen(),
        ),
      ),
    ).then((value) {
      // Refresh the voter list after adding a new voter
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VoterCubit, VoterState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _navigateToAddVoter(),
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

                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                //   decoration: BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(
                //         color: Theme.of(context).dividerColor.withOpacity(0.1),
                //       ),
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       GestureDetector(
                //         onTap: () => _navigateToAddVoter(),
                //         child: Container(
                //           padding: EdgeInsets.all(15),
                //           // width: 30,
                //           // height: 30,
                //           decoration: BoxDecoration(
                //             color: Theme.of(context).primaryColor,
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //           child: Icon(Iconsax.add, color: Colors.white),
                //         ),
                //       ),
                //       SizedBox(width: 10),
                //       Expanded(
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: Theme.of(context).cardColor,
                //             borderRadius: BorderRadius.circular(4.w),
                //             border: Border.all(
                //               color: Theme.of(
                //                 context,
                //               ).hintColor.withOpacity(0.2),
                //             ),
                //           ),
                //           child: TextField(
                //             controller: _searchController,
                //             // focusNode: _searchFocus,
                //             style: TextStyle(
                //               fontFamily: 'Cairo',
                //               color: Theme.of(
                //                 context,
                //               ).textTheme.bodyLarge?.color,
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400,
                //             ),
                //             textDirection: TextDirection.rtl,
                //             decoration: InputDecoration(
                //               hintText: 'ابحث عن ناخب ...',
                //               hintTextDirection: TextDirection.rtl,
                //               border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(8),

                //                 borderSide: BorderSide.none,
                //               ),
                //               hintStyle: TextStyle(
                //                 fontFamily: 'Cairo',
                //                 color: Theme.of(context).hintColor,
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //               ),
                //               filled: true,
                //               fillColor: Theme.of(context).cardColor,
                //               prefixIcon: Icon(Iconsax.search_normal_1),
                //               suffixIcon: _searchController.text.isNotEmpty
                //                   ? IconButton(
                //                       icon: Icon(
                //                         Iconsax.close_circle,
                //                         color: Theme.of(context).hintColor,
                //                       ),
                //                       onPressed: () {
                //                         _searchController.clear();
                //                         // _searchCubit.clearSearch();
                //                       },
                //                     )
                //                   : null,
                //             ),
                //             onChanged: (value) {
                //               _debouncedSearch(value);
                //             },
                //             onSubmitted: (value) {
                //               // _performSearch(value);
                //             },
                //             keyboardType: TextInputType.text,
                //             textInputAction: TextInputAction.search,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                _buildContent(state),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _navigateToAddVoter(),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   child: const Icon(Iconsax.user_add, color: Colors.white),
      // ),
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
                hintText: 'ابحث في عضر...',
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
                // _performSearch(value);
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                // _searchCubit.clearSearch();
              },
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

  Widget _buildContent(VoterState state) {
    switch (state) {
      case VoterLoading():
        return const Center(child: LoadingCustom());

      case VoterError():
        return Center(
          child: MessageWidgetCustom(
            message: 'حدث خطأ في تحميل البيانات: ${state.error}',
            isIconVisible: true,
            verticalPadding: 20,
            horizontalPadding: 20,
          ),
        );

      case VoterSuccess():
        return _buildVotersList(state.voters, state.meta);

      case VoterLoadingMore():
        return _buildVotersListWithLoadingMore(state.voters, state.meta);

      case VoterVotingSuccess():
        // Show success message and return to normal list
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل التصويت بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        });
        return _buildVotersList(state.voters, state.meta);

      case VoterVotingError():
        // Show error message and return to normal list
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ أثناء تسجيل التصويت: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        });
        return _buildVotersList(
          context.read<VoterCubit>().voters,
          context.read<VoterCubit>().meta!,
        );

      default:
        return const Center(
          child: MessageWidgetCustom(
            message: 'اضغط للتحديث',
            isIconVisible: true,
            verticalPadding: 20,
            horizontalPadding: 20,
          ),
        );
    }
  }

  Widget _buildVotersList(List<VoterModel> voters, VoterMeta meta) {
    if (voters.isEmpty) {
      return const Center(
        child: MessageWidgetCustom(
          message: 'لا توجد بيانات الاعضاء',
          isIconVisible: true,
          verticalPadding: 20,
          horizontalPadding: 20,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: voters.length + (meta.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == voters.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: LoadingCustom()),
          );
        }
        final isLastCard = index == voters.length - 1 && !meta.hasNextPage;
        return VoterCard(
          voter: voters[index],
          onTap: () => VoterDetailsBottomSheet.show(context, voters[index]),
          isLastCard: isLastCard,
        );
      },
    );
  }

  Widget _buildVotersListWithLoadingMore(
    List<VoterModel> voters,
    VoterMeta meta,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: voters.length + 1,
      itemBuilder: (context, index) {
        if (index == voters.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: LoadingCustom()),
          );
        }
        final isLastCard = index == voters.length - 1;
        return VoterCard(
          voter: voters[index],
          onTap: () => VoterDetailsBottomSheet.show(context, voters[index]),
          isLastCard: isLastCard,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
