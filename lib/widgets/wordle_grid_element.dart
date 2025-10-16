import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:wordle/theme/theme_data.dart';

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
  String _previousLetter = '';

  // Static constants for better performance
  static const BorderSide _transparentBorder =
      BorderSide(color: Colors.transparent, width: 2);
  static const double _emptyOpacity = 0.3;
  static const double _filledOpacity = 0.58;
  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(4));
  static const Duration _webAnimationDuration = Duration(milliseconds: 290);
  static const Duration _mobileAnimationDuration = Duration(milliseconds: 300);
  static const EdgeInsets _containerPadding = EdgeInsets.all(10);
  static const EdgeInsets _containerMargin = EdgeInsets.all(2);
  static const TextStyle _textStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: kIsWeb ? _webAnimationDuration : _mobileAnimationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _previousLetter = widget.letter;

    if (widget.letter.isNotEmpty) {
      _animateWithDebounce();
    }
  }

  void _animateWithDebounce() {
    if (_isAnimating) {
      _controller.value = 1.0;
      return;
    }

    _isAnimating = true;
    _controller.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WordleGridElement oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Store previous letter for animation transitions
    if (widget.letter != oldWidget.letter) {
      _previousLetter = oldWidget.letter;

      if (widget.letter.isNotEmpty) {
        _controller.stop();
        _animateWithDebounce();
      } else {
        _controller.value = 0.0;
        _isAnimating = false;
      }
    }

    // Handle attempt status change
    if (!oldWidget.attempted && widget.attempted) {
      _controller.reset();

      // Different delay for web vs mobile
      final delay = kIsWeb
          ? Duration(milliseconds: widget.pos * 50)
          : Duration(milliseconds: widget.pos * 200);

      Future.delayed(delay, () {
        if (mounted) {
          _animateWithDebounce();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    final BorderSide border = widget.attempted
        ? _transparentBorder
        : BorderSide(
            color: onSurface.withOpacity(
              widget.letter.isEmpty ? _emptyOpacity : _filledOpacity,
            ),
            width: 2,
          );

    final decoration = BoxDecoration(
      border: Border.fromBorderSide(border),
      color: widget.color ?? theme.colorScheme.surface,
      borderRadius: _borderRadius,
    );

    // Show previous letter during animation for a smoother transition
    final displayLetter =
        widget.letter.isEmpty && _previousLetter.isNotEmpty && _isAnimating
            ? _previousLetter
            : widget.letter;

    final textStyle = _textStyle.copyWith(
      color: widget.attempted
          ? Colors.white
          : AppTheme.gameColors.getTextColor(Theme.of(context).brightness),
    );

    final staticChild = Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      padding: _containerPadding,
      margin: _containerMargin,
      decoration: decoration,
      child: Text(
        displayLetter.toUpperCase(),
        style: textStyle,
      ),
    );

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        child: staticChild,
        builder: (context, child) {
          final scale = widget.letter.isEmpty ? 1.0 : _scaleAnimation.value;
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
      ),
    );
  }
}
