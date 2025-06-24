import 'package:flutter/material.dart';

import '../../domain/entities/modal_sheet_state.dart';

class ModalTopBar extends StatelessWidget {
  final ModalSheetState state;
  final VoidCallback onClose;
  final VoidCallback onMinimize;
  final VoidCallback onExpand;
  final VoidCallback onHalf;
  const ModalTopBar({super.key, required this.state, required this.onClose, required this.onMinimize, required this.onExpand, required this.onHalf});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (state == ModalSheetState.minimized)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          )
        else if (state == ModalSheetState.full)
          const SizedBox(width: 48) 
        else
          IconButton(
            icon: const Icon(Icons.expand_less),
            onPressed:  onExpand,
          ),
        const Spacer(),
        if (state == ModalSheetState.full)
          IconButton(
            icon: const Icon(Icons.expand_more),
            onPressed: onHalf,
          )
        else if (state == ModalSheetState.half)
          IconButton(
            icon: const Icon(Icons.expand_more),
            onPressed: onMinimize,
          ),
      ],
    );
  }
}
