import 'package:flutter/material.dart';
import 'package:test_tg/features/tma_modal/controller/tma_model_controller.dart';
import 'package:test_tg/features/tma_modal/domain/entities/modal_sheet_state.dart';

class TmaModalDragController {
  final TmaModalController modalController;
  bool isDragging = false;
  double dragStartY = 0;
  double dragStartHeight = 0;

  TmaModalDragController(this.modalController);

  void onDragStart(DragStartDetails details) {
    isDragging = true;
    dragStartY = details.globalPosition.dy;
    dragStartHeight = modalController.currentHeight;
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (!isDragging) return;
    final delta = details.globalPosition.dy - dragStartY;
    double newHeight = dragStartHeight - delta;
    newHeight = newHeight.clamp(modalController.minHeight, modalController.fullHeight);
    modalController.currentHeight = newHeight;
  }

  void onDragEnd(DragEndDetails details, VoidCallback onClose) {
    isDragging = false;
    final currentHeight = modalController.currentHeight;
    final distances = {
      ModalSheetState.minimized: (currentHeight - modalController.minHeight).abs(),
      ModalSheetState.half: (currentHeight - modalController.halfHeight).abs(),
      ModalSheetState.full: (currentHeight - modalController.fullHeight).abs(),
    };

    final closestState = distances.entries.reduce((a, b) => a.value < b.value ? a : b).key;
    double targetHeight = {
      ModalSheetState.minimized: modalController.minHeight,
      ModalSheetState.half: modalController.halfHeight,
      ModalSheetState.full: modalController.fullHeight,
    }[closestState]!;

    if (modalController.state == ModalSheetState.minimized &&
        details.primaryVelocity != null &&
        details.primaryVelocity! > 500) {
      onClose();
      return;
    }

    modalController.animateTo(targetHeight, closestState);
  }
}
