import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/common/widgets/image_network.dart';
import '../../models/voter_model.dart';

class VoterDetailsBottomSheet extends StatelessWidget {
  final VoterModel voter;

  const VoterDetailsBottomSheet({super.key, required this.voter});

  static void show(BuildContext context, VoterModel voter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoterDetailsBottomSheet(voter: voter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
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

                // Header with profile
                _buildDetailedHeader(context),
                const SizedBox(height: 30),

                // Detailed voter information
                _buildDetailedVoterInfo(context),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Profile image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: voter.cardImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: ImageNetworkCustom(
                      url: voter.cardImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.3),
                          Theme.of(context).primaryColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Icon(
                      Iconsax.user,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
          ),
          const SizedBox(height: 15),

          // Name
          Text(
            voter.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Phone
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.call, size: 16, color: Theme.of(context).hintColor),
              const SizedBox(width: 8),
              Text(
                voter.phone,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Status badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusBadge(
                voter.isVoted ? 'صوت' : 'لم يصوت',
                voter.isVoted ? Colors.green : Colors.red,
                voter.isVoted ? Iconsax.tick_circle : Iconsax.close_circle,
              ),
              _buildStatusBadge(
                voter.isActive == 1 ? 'فعال' : 'غير فعال',
                voter.isActive == 1 ? Colors.blue : Colors.grey,
                voter.isActive == 1
                    ? Iconsax.tick_circle
                    : Iconsax.close_circle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedVoterInfo(BuildContext context) {
    return Column(
      children: [
        // Personal Information Card
        _buildInfoCard(
          context,
          'المعلومات الشخصية',
          Iconsax.user,
          Colors.blue,
          [
            _buildInfoRow('الاسم الكامل:', voter.fullName),
            _buildInfoRow('رقم الهاتف:', voter.phone),
            _buildInfoRow('سنة الولادة:', voter.yearOfBirth),
            _buildInfoRow('الرقم:', voter.id.toString()),
          ],
        ),

        // Voting Status Card
        _buildInfoCard(
          context,
          'حالة التصويت',
          voter.isVoted ? Iconsax.tick_circle : Iconsax.clock,
          voter.isVoted ? Colors.green : Colors.orange,
          [
            _buildInfoRow(
              'حالة التصويت:',
              voter.isVoted ? 'تم التصويت' : 'لم يتم التصويت',
            ),
            _buildInfoRow(
              'حالة النشاط:',
              voter.isActive == 1 ? 'نشط' : 'غير نشط',
            ),
            _buildInfoRow(
              'البطاقة محدثة:',
              voter.isCardUpdated == 1 ? 'نعم' : 'لا',
            ),
          ],
        ),

        // Polling Center Card
        _buildInfoCard(context, 'مركز الاقتراع', Iconsax.location, Colors.red, [
          _buildInfoRow('اسم المركز:', voter.pollingCenter.name),
          _buildInfoRow('العنوان:', voter.pollingCenter.address),
          _buildInfoRow('الاسم الفعلي:', voter.pollingCenter.actualName),
          _buildInfoRow('الرقم:', voter.pollingCenter.number),
          _buildInfoRow(
            'عدد المحطات:',
            voter.pollingCenter.stationCount.toString(),
          ),
        ]),

        // Administrative Area Card
        _buildInfoCard(
          context,
          'المنطقة الإدارية',
          Iconsax.map,
          Colors.purple,
          [
            _buildInfoRow('الجانب:', voter.side.name),
            _buildInfoRow('المنطقة:', voter.area.name),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient background
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }


}
