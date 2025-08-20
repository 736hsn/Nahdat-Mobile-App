import 'dart:async';
import 'package:flutter/material.dart';

mixin CountdownTimerMixin<T extends StatefulWidget> on State<T> {
  Timer? _timer;
  int _remainingSeconds = 0;

  int get remainingSeconds => _remainingSeconds;
  bool get canResend => _remainingSeconds == 0;

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    if (minutes > 0) {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    }
    return seconds.toString();
  }

  void startTimer({int seconds = 60}) {
    setState(() {
      _remainingSeconds = seconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
