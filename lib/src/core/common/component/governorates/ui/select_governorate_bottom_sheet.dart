import 'package:supervisor/src/core/sizing/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/loading_indicator.dart';
import '../../../widgets/text.dart';
import '../logic/governorates_cubit.dart';
import '../logic/governorates_state.dart';

class SelectGovernorateBottomSheet extends StatelessWidget {
  final Function(String id, String name) onGovernorateSelected;

  const SelectGovernorateBottomSheet({
    super.key,
    required this.onGovernorateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        return Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(3.sp),
              topLeft: Radius.circular(3.sp),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 0.5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: TextCustom(
                  text: 'اختر المحافظة',
                  fontSize: 6.5,
                  height: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child:
                    state is FetchGovernoratesSuccess
                        ? ListView.builder(
                          itemCount: state.governorates.length,
                          itemBuilder: (_, index) {
                            final governorate = state.governorates[index];
                            return GestureDetector(
                              onTap: () {
                                context.pop();
                                onGovernorateSelected(
                                  governorate.id,
                                  governorate.name,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2.h,
                                  horizontal: 4.w,
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: 0.5.h,
                                  horizontal: 5.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextCustom(
                                  text: governorate.name.toLowerCase(),
                                  fontSize: 6.5,
                                  height: 1,
                                ),
                              ),
                            );
                          },
                        )
                        : state is FetchGovernoratesLoading
                        ? Center(child: LoadingCustom())
                        : Center(child: TextCustom(text: 'حدث خطا ما')),
              ),
            ],
          ),
        );
      },
    );
  }
}
