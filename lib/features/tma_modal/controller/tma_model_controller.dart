import 'package:flutter/material.dart';
import 'package:test_tg/features/tma_modal/domain/entities/modal_sheet_state.dart';

class TmaModalController with ChangeNotifier {
  late double minHeight, halfHeight, fullHeight;
  double currentHeight = 0;
  ModalSheetState state = ModalSheetState.half;

  late AnimationController animationController;
  late Animation<double> animation;

  final TickerProvider vsync;

  TmaModalController(this.vsync);

  void initializeHeights(BuildContext context) {
    final mq = MediaQuery.of(context);
    final padding = mq.viewInsets.bottom + mq.padding.bottom;
    fullHeight = mq.size.height - mq.padding.top - mq.padding.bottom;
    halfHeight = fullHeight * 0.5;
    minHeight = 80 + padding;
    currentHeight = halfHeight;
    notifyListeners(); 
  }

  void initAnimation() {
    animationController = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 0).animate(animationController);
  }

  void animateTo(double target, ModalSheetState newState) {
    animation = Tween<double>(begin: currentHeight, end: target).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease),
    )..addListener(() {
        currentHeight = animation.value;
        notifyListeners();
      });
    animationController.reset();
    animationController.forward();
    state = newState;
  }

  void disposeController() {
    animationController.dispose();
  }
}
