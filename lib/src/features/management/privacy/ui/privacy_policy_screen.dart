import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'سياسة الخصوصية'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: TextCustom(
                text: '📜 سياسة الخصوصية',
                fontSize: 6,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const TextCustom(
              text:
                  'في منظمة نهضة العراق لتطوير الشباب، نلتزم بحماية خصوصية بيانات جميع مستخدمينا وأعضاء مجتمعنا. يتم جمع البيانات الشخصية فقط للأغراض التدريبية والتنظيمية وتطوير الخدمات المقدمة، ولن يتم مشاركة معلوماتك مع أي جهة خارجية دون موافقتك المسبقة، إلا إذا تطلب الأمر ذلك قانونياً.',
              fontSize: 6,
              textAlign: TextAlign.right,
              height: 2,
              maxLines: 33,
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. جمع البيانات',
              'نقوم بجمع بيانات أساسية مثل الاسم، رقم الهاتف، البريد الإلكتروني، أو أي معلومات أخرى لازمة للتسجيل في الدورات والفعاليات التي نقدمها. يتم تخزين هذه البيانات بأمان واتخاذ جميع التدابير التقنية والإدارية اللازمة لمنع الوصول غير المصرح به.',
            ),
            _buildSection(
              '2. الموافقة والتحديثات',
              'من خلال استخدامك لتطبيقنا وخدماتنا، فإنك توافق على سياسة الخصوصية هذه وتقر بحقنا في تحديثها بما يتماشى مع القوانين والتعليمات المحلية والدولية. سيتم إعلام جميع المستخدمين بأي تحديثات مهمة تطرأ على هذه السياسة.',
            ),
            _buildSection(
              '3. التواصل معنا',
              'إذا كان لديك أي استفسارات أو طلبات بخصوص بياناتك الشخصية، يمكنك التواصل معنا عبر مقرنا في بغداد - شارع ٦٢ حي الوحدة، أو من خلال قنوات الاتصال الرسمية للمنظمة.',
            ),
            const SizedBox(height: 24),
            const Center(
              child: TextCustom(
                text: 'معاً نبني مستقبلاً آمناً ومحترماً للخصوصية.',
                fontSize: 6,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextCustom(
          text: title,
          fontSize: 6,
          height: 2,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.right,
          maxLines: 33,
        ),
        const SizedBox(height: 8),
        TextCustom(
          text: content,
          fontSize: 6,
          height: 2,
          textAlign: TextAlign.right,
          maxLines: 33,
        ),
      ],
    );
  }
}
