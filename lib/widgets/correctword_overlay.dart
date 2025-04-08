import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/theme/theme_data.dart';
import 'package:wordle/widgets/wordle_grid_element.dart';

class CorrectWordOverlay {
  OverlayEntry? _overlayEntry;
  final String correctWord;
  final FocusNode _focusNode = FocusNode();

  CorrectWordOverlay({
    required this.correctWord,
  });

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);

        return Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: KeyboardListener(
            focusNode: _focusNode,
            onKeyEvent: (KeyEvent event) {
              if (event is KeyDownEvent &&
                  (event.logicalKey == LogicalKeyboardKey.space ||
                      event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.escape ||
                      event.logicalKey == LogicalKeyboardKey.backspace)) {
                hide();
              }
            },
            child: GestureDetector(
              onTap: hide,
              child: Material(
                color: theme.brightness == Brightness.dark
                    ? Colors.black87
                    : Colors.black54,
                child: Center(
                  child: GestureDetector(
                    onTap:
                        () {}, // Prevent taps on the container from closing the overlay
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Correct Word',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              correctWord.length,
                              (index) => WordleGridElement(
                                pos: index,
                                letter: correctWord[index],
                                attempted: true,
                                color: AppTheme.gameColors.incorrectColor
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextButton(
                            onPressed: hide,
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                    
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    // Request focus so keyboard events are captured
    _focusNode.requestFocus();
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void dispose() {
    _focusNode.dispose();
  }
}
