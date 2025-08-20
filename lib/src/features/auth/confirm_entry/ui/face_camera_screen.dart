import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:supervisor/src/core/common/widgets/text.dart';

class FaceCameraScreen extends StatefulWidget {
  const FaceCameraScreen({super.key});

  @override
  State<FaceCameraScreen> createState() => _FaceCameraScreenState();
}

class _FaceCameraScreenState extends State<FaceCameraScreen> {
  late FaceCameraController controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    try {
      controller = FaceCameraController(
        autoCapture: false,
        defaultCameraLens: CameraLens.front,
        onCapture: (File? image) {
          if (image != null) {
            Navigator.pop(context, image);
          } else {
            _showError('فشل في التقاط الصورة');
          }
        },
        onFaceDetected: (Face? face) {
          // Handle face detection if needed
          if (mounted) {
            setState(() {
              // Update UI based on face detection
            });
          }
        },
      );

      // Add a small delay to ensure camera is ready
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('خطأ في تهيئة الكاميرا: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'التقاط صورة الوجه',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          if (_isCameraInitialized)
            SmartFaceCamera(
              controller: controller,
              message: 'ضع وجهك في الإطار',
              messageStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              showCaptureControl: true,

              showFlashControl: true,
              showCameraLensControl: true,
              autoDisableCaptureControl: false,
              messageBuilder: (context, face) {
                if (face == null) {
                  return _buildMessage('ضع وجهك في الإطار');
                }
                if (!face.wellPositioned) {
                  return _buildMessage('اضبط موقع وجهك');
                }
                return _buildMessage('ممتاز! اضغط لالتقاط الصورة');
              },
            )
          else
            _buildLoadingScreen(),
          if (_isCameraInitialized)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextCustom(
                      text: 'نصائح للحصول على أفضل نتيجة:',
                      color: Colors.white,
                      fontSize: 5,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    TextCustom(
                      text:
                          '• تأكد من وجود إضاءة جيدة\n• انظر مباشرة إلى الكاميرا\n• احرص على استقرار الهاتف',
                      color: Colors.white70,
                      fontSize: 4,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextCustom(
        text: message,
        color: Colors.white,
        fontSize: 5,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            TextCustom(
              text: 'جاري تحضير الكاميرا...',
              color: Colors.white,
              fontSize: 6,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextCustom(
              text: 'يرجى التأكد من تفعيل صلاحية الكاميرا',
              color: Colors.white70,
              fontSize: 4,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
