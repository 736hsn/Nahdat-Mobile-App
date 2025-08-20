import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/common/widgets/text.dart';
import '../../../../core/common/widgets/image_network.dart';
import '../../models/voter_model.dart';
import '../../logic/voter_cubit.dart';

class VoterCard extends StatelessWidget {
  final VoterModel voter;
  final VoidCallback onTap;
  final bool isLastCard;

  const VoterCard({
    super.key,
    required this.voter,
    required this.onTap,
    this.isLastCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).hintColor.withOpacity(0.05),
          width: 1,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      margin: EdgeInsets.only(bottom: isLastCard ? 116 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and status
              Row(
                children: [
                  // Profile image or avatar
                  _buildProfileImage(context),
                  const SizedBox(width: 16),

                  // Name and basic info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          text: voter.fullName,
                          fontSize: 5,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        TextCustom(
                          text: 'الهاتف: ${voter.phone}',
                          fontSize: 4,
                          color: Theme.of(context).hintColor,
                        ),
                        TextCustom(
                          text: 'سنة الولادة: ${voter.yearOfBirth}',
                          fontSize: 4,
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ),

                  // Status indicators
                  _buildStatusIndicators(context),
                ],
              ),

              const SizedBox(height: 16),
              _buildGradientDivider(context),
              const SizedBox(height: 12),

              // Location info
              _buildLocationInfo(context),
              const SizedBox(height: 12),

              // Administrative area
              _buildAdministrativeArea(context),
              const SizedBox(height: 8),
              const SizedBox(height: 16),

              // Voting button
              _buildVotingButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.5),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: voter.cardImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(32.5),
              child: ImageNetworkCustom(
                url: voter.cardImage!,
                width: 65,
                height: 65,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.5),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.05),
                    Theme.of(context).primaryColor.withOpacity(0.025),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Iconsax.user,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }

  Widget _buildStatusIndicators(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: voter.isVoted
                  ? [Colors.green, Colors.green.withOpacity(0.8)]
                  : [Colors.red, Colors.red.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: (voter.isVoted ? Colors.green : Colors.red).withOpacity(
                  0.3,
                ),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                voter.isVoted ? Iconsax.tick_circle : Iconsax.close_circle,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              TextCustom(
                text: voter.isVoted ? 'صوت' : 'لم يصوت',
                fontSize: 4,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: voter.isActive == 1
                  ? [Colors.blue, Colors.blue.withOpacity(0.8)]
                  : [Colors.grey, Colors.grey.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: (voter.isActive == 1 ? Colors.blue : Colors.grey)
                    .withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                voter.isActive == 1
                    ? Iconsax.tick_circle
                    : Iconsax.close_circle,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              TextCustom(
                text: voter.isActive == 1 ? 'فعال' : 'غير فعال',
                fontSize: 4,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGradientDivider(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Theme.of(context).hintColor.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.location, color: Colors.red, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مركز الاقتراع: ${voter.pollingCenter.name}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                voter.pollingCenter.address,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdministrativeArea(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Iconsax.map, color: Colors.purple, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '${voter.side.name} - ${voter.area.name}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildVotingButton(BuildContext context) {
    return BlocBuilder<VoterCubit, VoterState>(
      builder: (context, state) {
        final cubit = context.read<VoterCubit>();
        final isVotingInProgress = cubit.votingInProgress == voter.id;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: voter.isVoted
                  ? [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ]
                  : [
                      Theme.of(context).primaryColor.withOpacity(0.05),
                      Theme.of(context).primaryColor.withOpacity(0.025),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  (voter.isVoted
                          ? Colors.green
                          : Theme.of(context).primaryColor)
                      .withOpacity(0.3),
            ),
          ),
          child: OutlinedButton(
            onPressed: voter.isVoted || isVotingInProgress
                ? null
                : () async {
                    await cubit.markVoterAsVoted(voter.id);
                  },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.transparent,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isVotingInProgress
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        voter.isVoted ? Iconsax.tick_circle : Iconsax.user_tick,
                        size: 20,
                        color: voter.isVoted
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      TextCustom(
                        text: voter.isVoted ? 'تم التصويت' : 'تصويت',
                        fontSize: 5,
                        fontWeight: FontWeight.w600,
                        color: voter.isVoted
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
