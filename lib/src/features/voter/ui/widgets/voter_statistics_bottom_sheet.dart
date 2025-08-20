import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../logic/voter_cubit.dart';

class VoterStatisticsBottomSheet extends StatelessWidget {
  const VoterStatisticsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoterStatisticsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconsax.chart,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'إحصائيات ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            BlocBuilder<VoterCubit, VoterState>(
              builder: (context, state) {
                final cubit = context.read<VoterCubit>();
                return Column(
                  children: [
                    _buildStatCard(
                      context,
                      'إجمالي الاعضاء',
                      cubit.totalVoters.toString(),
                      Iconsax.people,
                      Colors.blue,
                      cubit.totalVoters,
                    ),
                    _buildStatCard(
                      context,
                      'الذين صوتوا',
                      cubit.votedVoters.length.toString(),
                      Iconsax.tick_circle,
                      Colors.green,
                      cubit.totalVoters,
                    ),
                    _buildStatCard(
                      context,
                      'لم يصوتوا',
                      cubit.notVotedVoters.length.toString(),
                      Iconsax.clock,
                      Colors.red,
                      cubit.totalVoters,
                    ),
                    _buildStatCard(
                      context,
                      'الفعالين',
                      cubit.activeVoters.length.toString(),
                      Iconsax.tick_circle,
                      Colors.teal,
                      cubit.totalVoters,
                    ),
                    _buildStatCard(
                      context,
                      'غير الفعالين',
                      cubit.inactiveVoters.length.toString(),
                      Iconsax.close_circle,
                      Colors.grey,
                      cubit.totalVoters,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    int totalVoters,
  ) {
    final int numericValue = int.tryParse(value) ?? 0;
    final double percentage = totalVoters > 0
        ? (numericValue / totalVoters) * 100
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (title != 'إجمالي الاعضاء') ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
