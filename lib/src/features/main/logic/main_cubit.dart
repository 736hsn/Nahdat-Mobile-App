import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainCubit extends Cubit<int> {
  final PageController pageController = PageController(initialPage: 0);

  MainCubit() : super(0) {
    log('Cubit created!');
  }

  void navigateTo(int index) {
    if (index != state) {
      pageController.jumpToPage(index);
      emit(index);
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
