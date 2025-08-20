import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:supervisor/src/core/common/widgets/shimmer_container.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:supervisor/src/features/voter/logic/add_voter_cubit.dart';
import 'package:supervisor/src/features/voter/ui/add_voter_screen.dart';
import '../logic/home_cubit.dart';
import '../logic/home_state.dart';
import '../models/statistics_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Refresh data when pull-to-refresh is triggered
    context.read<HomeCubit>().loadStatistics();
  }

  void _navigateToAddVoter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<AddVoterCubit>(
          create: (context) => getIt<AddVoterCubit>(),
          child: const AddVoterScreen(),
        ),
      ),
    ).then((value) {
      // Refresh the statistics after adding a new voter
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          (state is HomeLoaded &&
                              state.isInsidePollingCenter == true)
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      width: 1,
                    ),
                    color:
                        (state is HomeLoaded &&
                            state.isInsidePollingCenter == true)
                        ? Colors.green.withOpacity(0.05)
                        : Colors.redAccent.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  // height: 100,
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.building_3,
                        size: 20,
                        color:
                            (state is HomeLoaded &&
                                state.isInsidePollingCenter == true)
                            ? Colors.green.withOpacity(0.7)
                            : Colors.red.withOpacity(0.7),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextCustom(
                            text:
                                (state is HomeLoaded &&
                                    state.isInsidePollingCenter == true)
                                ? ' داخل مركز التصويت'
                                : ' خارج مركز التصويت',
                            fontSize: 5,
                            fontWeight: FontWeight.w600,
                            color:
                                (state is HomeLoaded &&
                                    state.isInsidePollingCenter == true)
                                ? Colors.green.withOpacity(0.7)
                                : Colors.red.withOpacity(0.7),
                          ),
                          TextCustom(
                            text:
                                state is HomeLoaded &&
                                    state.locationMessage != null
                                ? ' ${state.locationMessage}'
                                : ' جاري تحديد المسافة...',
                            fontSize: 4.5,
                            isSubTitle: true,
                            // fontWeight: FontWeight.bold,
                            // color: Colors.black,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextCustom(
                    textAlign: TextAlign.start,
                    text: 'إحصائيات ',
                    fontSize: 6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                if (state is HomeLoading)
                  _buildShimmerStatistics()
                else if (state is HomeError)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextCustom(
                              text: state.error,
                              fontSize: 4.5,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is HomeLoaded)
                  _buildStatisticsSection(state.statistics)
                else
                  _buildStatisticsSection(StatisticsModel.empty()),

                _buildQuickActions(),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsSection(StatisticsModel statistics) {
    return Column(
      children: [
        _buildStatsSection(
          'إجمالي الاعضاء',
          statistics.totalVoters.toString(),
          Iconsax.people,
        ),
        Row(
          children: [
            Expanded(
              child: _buildStatsSection(
                'الذين صوتوا',
                statistics.voted.toString(),
                Iconsax.people,
              ),
            ),
            Expanded(
              child: _buildStatsSection(
                'لم يصوتوا',
                statistics.notVoted.toString(),
                Iconsax.people,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildStatsSection(
                'الفعالين',
                statistics.activeVoters.toString(),
                Iconsax.people,
              ),
            ),
            Expanded(
              child: _buildStatsSection(
                'غير الفعالين',
                statistics.inactiveVoters.toString(),
                Iconsax.people,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Iconsax.people, size: 20),
              const SizedBox(width: 10),
              TextCustom(
                text: title,
                fontSize: 5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextCustom(
                text: '$value/',
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              TextCustom(
                text: 'عضو',
                fontSize: 5,
                isSubTitle: true,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(
            text: 'الإجراءات السريعة',
            fontSize: 6,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          const SizedBox(height: 16),

          _buildActionCard('تاكيد دخول', Iconsax.login, Colors.blue, () {
            context.pushNamed('confirm_entry');
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'إضافة عضو',
                  Iconsax.add,
                  Colors.blue,
                  () {
                    _navigateToAddVoter();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'إضافة شريط',
                  Iconsax.add,
                  Colors.purple,
                  () {
                    context.pushNamed('add_strip');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(height: 12),
                // Expanded(
                //   child:
                TextCustom(
                  text: title,
                  fontSize: 5,
                  maxLines: 2,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerStatistics() {
    return Column(
      children: [
        // إجمالي الناخبين shimmer
        _buildShimmerStatsSection(),

        // صف الذين صوتوا ولم يصوتوا
        Row(
          children: [
            Expanded(child: _buildShimmerStatsSection()),
            Expanded(child: _buildShimmerStatsSection()),
          ],
        ),

        // صف الفعالين وغير الفعالين
        Row(
          children: [
            Expanded(child: _buildShimmerStatsSection()),
            Expanded(child: _buildShimmerStatsSection()),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ShimmerContainerCustom(height: 20, width: 20, borderRadius: 10),
              const SizedBox(width: 10),
              ShimmerContainerCustom(height: 16, width: 80, borderRadius: 8),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ShimmerContainerCustom(height: 24, width: 40, borderRadius: 6),
              const SizedBox(width: 10),
              ShimmerContainerCustom(height: 16, width: 30, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
