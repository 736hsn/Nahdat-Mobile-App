import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/theme_aware_logo.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'من نحن ؟'),
      // centerTitle: true,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11.0),
                child: Column(
                  children: [
                    FadeIn(
                      duration: const Duration(milliseconds: 800),
                      child: ThemeAwareLogo(height: 100),
                    ),
                    FadeIn(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 300),
                      child: TextCustom(
                        text: 'نهضة العراق لتطوير الشباب',
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            // Center(
            //   child: ImageAssetCustom(
            //     img: 'logo',
            //     height: 50,
            //     fit: BoxFit.contain,
            //   ),
            // ),
            FadeIn(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 400),
              child: const TextCustom(
                text: 'من نحن ؟',
                fontSize: 6,
                fontWeight: FontWeight.bold,
                maxLines: 44,
                textAlign: TextAlign.right,
              ),
            ),

            const SizedBox(height: 16),
            FadeIn(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 600),
              child: const TextCustom(
                maxLines: 44,
                text:
                    'نحن منظمة نهضة العراق لتطوير الشباب، منظمة مستقلة غير حكومية تأسست لتكون منبراً داعماً للشباب العراقي الطموح، من خلال تطوير قدراتهم وتمكينهم من اكتساب المهارات الحديثة في مجالات الذكاء الاصطناعي، التحول الرقمي، والتكنولوجيا.',
                fontSize: 6,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 16),
            FadeIn(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 800),
              child: const TextCustom(
                maxLines: 44,
                text:
                    'نؤمن بأن الشباب هم ركيزة المستقبل ونهضة الوطن، لذلك نسعى إلى توفير بيئة تعليمية وتدريبية متكاملة، من ورش عمل ودورات تدريبية وبرامج تأهيلية، تُساعدهم على مواكبة التطورات التقنية والاستفادة منها في بناء مسارات مهنية ناجحة.',
                fontSize: 6,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 16),
            FadeIn(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 1000),
              child: const TextCustom(
                maxLines: 44,
                text:
                    'يقع مقرنا الرئيسي في بغداد - شارع ٦٢ حي الوحدة، ونفتح أبوابنا لكل شاب وشابة يرغبون بأن يكونوا جزءاً من هذا التغيير الإيجابي نحو عراق رقمي متطور، يقوده جيل واعٍ قادر على الإبداع والابتكار.',
                fontSize: 6,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 16),
            FadeIn(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 1200),
              child: const TextCustom(
                maxLines: 44,
                text:
                    'انضموا إلينا لنبني معاً جسوراً من المعرفة، ونُحدث أثراً حقيقياً في المجتمع من خلال الاستثمار في طاقات الشباب وتوجيهها نحو مستقبل أفضل.',
                fontSize: 6,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 24),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     _socialMediaButton(Icons.facebook, 'Facebook'),
            //     const SizedBox(width: 16),
            //     _socialMediaButton(Iconsax.global, 'Website'),
            //     const SizedBox(width: 16),
            //     _socialMediaButton(Iconsax.play_circle5, 'YouTube'),
            //   ],
            // ),
            const SizedBox(height: 12),
            FadeIn(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 1600),
              child: const Center(
                child: TextCustom(
                  text: '© 2025 نهضة العراق لتطوير الشباب - جميع الحقوق محفوظة',
                  fontSize: 4.5,
                  isSubTitle: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _socialMediaButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(icon: Icon(icon, size: 32), onPressed: () {}),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
