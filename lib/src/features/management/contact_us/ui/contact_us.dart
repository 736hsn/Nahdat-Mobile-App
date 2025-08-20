import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/image_assets.dart';
import 'package:supervisor/src/core/common/widgets/theme_aware_logo.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF085B8D); // Primary brand color
    final textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final cardColor = isDarkMode
        ? const Color(0xFF252525)
        : const Color(0xFFF7F6FF);

    return Scaffold(
      appBar: AppBarCustom(title: 'تواصل معنا'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11.0),
                child: FadeIn(
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: ThemeAwareLogo(height: 100),
                      ),
                      Center(
                        child: TextCustom(
                          text: "نهضة العراق لتطوير الشباب",
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),

            // Social Media Section
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: TextCustom(
                text: 'تواصل معنا',
                fontSize: 6,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            // Social Media Section
            const SizedBox(height: 16),

            // Social Media Cards
            // ... existing code ...
            _buildSocialMediaCard(
              context,
              'فيسبوك',
              'https://www.facebook.com/',
              'facebook',
              const Color(0xFF1877F2),
              cardColor,
              textColor,
            ),
            _buildSocialMediaCard(
              context,
              'تويتر / X',
              'https://x.com',
              'x',
              Colors.grey,
              cardColor,
              textColor,
            ),
            _buildSocialMediaCard(
              context,
              'انستغرام',
              'https://www.instagram.com/nahdat_aliraq/?hl=ar',
              'instagram',
              const Color(0xFFE1306C),
              cardColor,
              textColor,
            ),
            _buildSocialMediaCard(
              context,
              'يوتيوب',
              'https://www.youtube.com/',
              'youtube',
              const Color(0xFFFF0000),
              cardColor,
              textColor,
            ),
            _buildSocialMediaCard(
              context,
              'تليجرام',
              'https://t.me',
              'telegram',
              const Color(0xFF0088CC),
              cardColor,
              textColor,
            ),
            _buildSocialMediaCard(
              context,
              'تيك توك',
              'https://www.tiktok.com/',
              'tiktok',
              Colors.grey,
              cardColor,
              textColor,
            ),

            // ... existing code ...
            const SizedBox(height: 32),

            // Direct Contact Section
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              child: TextCustom(
                text: 'التواصل المباشر',
                fontSize: 6,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildContactItem(
                        context,
                        Icons.email,
                        'البريد الإلكتروني',
                        'info@nahda.iq',
                        () => _launchUrl('mailto:info@nahda.iq'),
                        textColor,
                        primaryColor,
                      ),
                      const Divider(),
                      _buildContactItem(
                        context,
                        Icons.phone,
                        'اتصل بنا',
                        '+964 770 000 0000',
                        () => _launchUrl('tel:+9647700000000'),
                        textColor,
                        primaryColor,
                      ),
                      const Divider(),
                      _buildContactItem(
                        context,
                        Icons.location_on,
                        'الموقع',
                        'بغداد, العراق',
                        () => _launchUrl(
                          'https://maps.app.goo.gl/tWQcbaPAw6RsbE11A',
                        ),
                        textColor,
                        primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaCard(
    BuildContext context,
    String platform,
    String url,
    String imageAsset,
    Color iconColor,
    Color cardColor,
    Color textColor,
  ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),

          child: InkWell(
            onTap: () => _launchUrl(url),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImageAssetCustom(
                        img: imageAsset,
                        width: 29,
                        height: 29,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          text: platform,
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        const SizedBox(height: 4),
                        TextCustom(
                          text: "نهضة العراق لتطوير الشباب",
                          fontSize: 4,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Iconsax.arrow_left_2,
                    size: 22,
                    color: textColor.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    Color textColor,
    Color primaryColor,
  ) {
    return FadeInRight(
      duration: const Duration(milliseconds: 500),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: primaryColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      text: title,
                      fontSize: 7,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    const SizedBox(height: 4),
                    TextCustom(
                      text: subtitle,
                      fontSize: 5,
                      color: textColor.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: subtitle));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.copy, size: 20, color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
