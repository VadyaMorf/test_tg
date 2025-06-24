
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_tg/features/tma_modal/controller/tma_drag_controller.dart';
import 'package:test_tg/features/tma_modal/controller/tma_model_controller.dart';
import 'package:test_tg/features/tma_modal/domain/entities/modal_sheet_state.dart';
import 'package:test_tg/features/tma_modal/presentation/widgets/drag_bar.dart';
import 'package:test_tg/features/tma_modal/presentation/widgets/modal_top_bar.dart';
import 'package:test_tg/features/tma_modal/presentation/widgets/persistent_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TmaModalPage extends StatefulWidget {
  final String url;
  const TmaModalPage({super.key, required this.url});

  @override
  State<TmaModalPage> createState() => _TmaModalPageState();
}

class _TmaModalPageState extends State<TmaModalPage> with SingleTickerProviderStateMixin {
  late TmaModalController _controller;
  bool _isDragging = false;
  bool _backgroundVisible = false;
  late final WebViewController _webViewController;
  late TmaModalDragController _dragController;

  @override
  void initState() {
    super.initState();
    _controller = TmaModalController(this);
    _dragController = TmaModalDragController(_controller);
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeHeights(context);
      _controller.initAnimation();
      setState(() {
        _backgroundVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.disposeController();
    super.dispose();
  }

  void _onClose() {
    setState(() {
      _backgroundVisible = false;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: _backgroundVisible ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: _controller.state == ModalSheetState.minimized ? _onClose : null,
                  child: Container(color: Colors.black.withAlpha((0.2 * 255).toInt())),
                ),
              ),
              AnimatedPositioned(
                duration: _isDragging ? Duration.zero : const Duration(milliseconds: 200),
                curve: Curves.ease,
                left: 0,
                right: 0,
                bottom: 0,
                height: _controller.currentHeight + mq.viewInsets.bottom,
                child: Material(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          ModalTopBar(
                            state: _controller.state,
                            onClose: _onClose,
                            onMinimize: () => _controller.animateTo(_controller.minHeight, ModalSheetState.minimized),
                            onHalf: () => _controller.animateTo(_controller.halfHeight, ModalSheetState.half),
                            onExpand: () => _controller.animateTo(_controller.fullHeight, ModalSheetState.full),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: PersistentWebView(controller: _webViewController),
                            ),
                          ),
                          SizedBox(height: mq.padding.bottom),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: DragBar(
                          onDragStart: _dragController.onDragStart,
                          onDragUpdate: _dragController.onDragUpdate,
                          onDragEnd: (details) => _dragController.onDragEnd(details, _onClose),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
