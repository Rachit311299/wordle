import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wordle/widgets/history_tab.dart';

Future<void> showHistoryDialog(BuildContext context) async {
  final theme = Theme.of(context);
  await showGeneralDialog(
    context: context,
    barrierLabel: 'History',
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, anim1, anim2) {
      // Content is built in transitionBuilder
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final blurSigma = 8.0 * curve.value; // animate blur from first frame
      final opacity = curve.value;

      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: 0.98 + 0.02 * curve.value,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560, maxHeight: 600),
                  child: Material(
                    color: theme.colorScheme.surface.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              border: Border(
                                bottom: BorderSide(
                                  color: theme.colorScheme.onSurface.withOpacity(0.08),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'History',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                                )
                              ],
                            ),
                          ),
                          const Expanded(child: HistoryTab()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}


