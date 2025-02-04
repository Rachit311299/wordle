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
      duration: Duration(milliseconds: kIsWeb ? 290 : 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
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
        Future.delayed(Duration(milliseconds: widget.pos * 200), () {
          if (mounted) {
            _animateWithDebounce();
          }
        });
      } else {
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
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.letter.isEmpty ? 1.0 : _scaleAnimation.value,
            child: _GridTile(
              letter: widget.letter,
              attempted: widget.attempted,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  final String letter;
  final bool attempted;
  final Color? color;

  const _GridTile({
    required this.letter,
    required this.attempted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          attempted
              ? const BorderSide(color: Colors.transparent, width: 2)
              : BorderSide(
                  color: onSurface.withOpacity(letter.isEmpty ? 0.3 : 0.58),
                  width: 2,
                ),
        ),
        color: color ?? theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        letter.toUpperCase(),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: attempted ? Colors.white : onSurface,
        ),
      ),
    );
  }
}
