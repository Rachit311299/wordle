import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class WordleGridElement extends StatefulWidget {
  final int pos;
  final String letter;
  final bool attempted;
  final Color? color;

  const WordleGridElement({
    super.key,
    required this.pos,
    required this.letter,
    required this.attempted,
    required this.color,
  });

  @override
  State<WordleGridElement> createState() => _WordleGridElementState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('pos', pos));
    properties.add(StringProperty('letter', letter));
    properties.add(DiagnosticsProperty<bool>('attempted', attempted));
    properties.add(ColorProperty('color', color));
  }
}

class _WordleGridElementState extends State<WordleGridElement>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: kIsWeb ? 290 : 300), // Faster animation on web
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut, // Simpler curve for web
      ),
    );

    if (widget.letter.isNotEmpty) {
      _animateWithDebounce();
    }
  }

  void _animateWithDebounce() {
    if (_isAnimating) return;
    _isAnimating = true;
    _controller.forward().then((_) => _isAnimating = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WordleGridElement oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.letter != oldWidget.letter && widget.letter.isNotEmpty) {
      _controller.reset();
      _animateWithDebounce();
    }

    if (!oldWidget.attempted && widget.attempted) {
      _controller.reset();
      if (!kIsWeb) {
        // Only delay on non-web platforms
        Future.delayed(Duration(milliseconds: widget.pos * 200), () {
          if (mounted) {
            _animateWithDebounce();
          }
        });
      } else {
        // Immediate animation on web with minimal delay
        Future.delayed(Duration(milliseconds: widget.pos * 50), () {
          if (mounted) {
            _animateWithDebounce();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use RepaintBoundary to isolate animations
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.letter.isEmpty ? 1.0 : _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: widget.attempted
                ? null // Remove border when attempted to reduce repaints
                : Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(
                        widget.letter.isEmpty ? 0.3 : 0.58),
                    width: 2),
            color: widget.color ?? Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Text(
            widget.letter.toUpperCase(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: widget.attempted
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
