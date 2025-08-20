import 'package:supervisor/src/core/common/widgets/app_bar.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:async';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: '1. ما هي منظمة نهضة العراق لتطوير الشباب؟',
      answer:
          'هي منظمة مستقلة غير حكومية تهدف إلى تطوير قدرات الشباب العراقي في مجالات الذكاء الاصطناعي، التحول الرقمي، والتكنولوجيا من خلال ورش عمل ودورات تدريبية وبرامج تأهيلية.',
    ),
    FAQItem(
      question: '2. من يمكنه الانضمام إلى برامج المنظمة؟',
      answer:
          'جميع الشباب والشابات من مختلف الأعمار والتخصصات الذين لديهم الرغبة في تطوير مهاراتهم التقنية ومواكبة التطورات التكنولوجية يمكنهم الانضمام إلينا.',
    ),
    FAQItem(
      question: '3. هل المشاركة في البرامج مجانية؟',
      answer:
          'تختلف طبيعة البرامج حسب نوع النشاط. بعض الدورات وورش العمل تكون مجانية تماماً، وأخرى قد تتطلب رسوماً رمزية لضمان استدامة الأنشطة وتوفير أفضل جودة تدريبية.',
    ),
    FAQItem(
      question: '4. كيف يمكنني التسجيل في الدورات أو الفعاليات؟',
      answer:
          'يمكنك التسجيل بسهولة عبر التطبيق الخاص بالمنظمة أو زيارة مقرنا في بغداد - شارع ٦٢ حي الوحدة، كما نوفر رابطاً مباشراً للتسجيل في كل إعلان عن دورة أو فعالية.',
    ),
    FAQItem(
      question: '5. كيف يتم استخدام بياناتي الشخصية؟',
      answer:
          'نلتزم بالحفاظ على سرية بياناتك وفقاً لـ سياسة الخصوصية الخاصة بنا، ويتم استخدامها فقط للأغراض التنظيمية والتدريبية.',
    ),
    FAQItem(
      question: '6. هل أستطيع التطوع مع المنظمة؟',
      answer:
          'نعم! نرحب بجميع المبادرات التطوعية التي تسهم في تحقيق أهداف المنظمة، ويمكنك التقديم للتطوع عبر التطبيق أو التواصل معنا مباشرةً.',
    ),
    FAQItem(
      question: '7. كيف أتواصل مع فريق الدعم؟',
      answer:
          'يمكنك التواصل معنا من خلال معلومات الاتصال الموجودة داخل التطبيق، أو زيارة مقرنا الرسمي في أي وقت خلال ساعات الدوام.',
    ),
  ];

  int visibleItems = 0;
  List<bool> isTypingComplete = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize all items as not visible initially
    isTypingComplete = List.generate(faqItems.length, (_) => false);
    // Show the first item after a short delay
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          visibleItems = 1;
        });
      }
    });
  }

  void onTypingComplete(int index) {
    setState(() {
      isTypingComplete[index] = true;
      // If this isn't the last item, show the next one
      if (index < faqItems.length - 1 && visibleItems == index + 1) {
        Timer(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              visibleItems++;
            });
            // Scroll to the newly visible item
            Timer(const Duration(milliseconds: 100), () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBarCustom(title: 'الأسئلة الشائعة'),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeIn(
              duration: const Duration(milliseconds: 300),
              child: const Center(
                child: TextCustom(
                  text: 'الأسئلة الشائعة - منظمة نهضة العراق لتطوير الشباب',
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              visibleItems,
              (index) => _buildFaqItem(
                context: context,
                question: faqItems[index].question,
                answer: faqItems[index].answer,
                index: index,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required int index,
    BuildContext? context,
  }) {
    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // User Question - Right aligned
          Container(
            margin: const EdgeInsets.only(left: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context!).primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: 'Cairo',
                ),
                child: Text(question),
              ),
            ),
          ),

          const SizedBox(height: 10),
          // AI Response - Left aligned with typing animation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 16,
                        height: 1.5,
                        fontFamily: 'Cairo',
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            answer,
                            textAlign: TextAlign.right,
                            speed: const Duration(milliseconds: 15),
                            cursor: '|',
                          ),
                        ],
                        displayFullTextOnTap: true,
                        isRepeatingAnimation: false,
                        totalRepeatCount: 1,
                        onFinished: () => onTypingComplete(index),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
