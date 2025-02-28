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
  late final BorderSide _transparentBorder;
  late final double _emptyOpacity;
  late final double _filledOpacity;
  String _previousLetter = '';

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

    // Pre-calculate values
    _transparentBorder = const BorderSide(color: Colors.transparent, width: 2);
    _emptyOpacity = 0.3;
    _filledOpacity = 0.58;
    
    _previousLetter = widget.letter;

    if (widget.letter.isNotEmpty) {
      _animateWithDebounce();
    }
  }

  void _animateWithDebounce() {
    if (_isAnimating) {
      _controller.value = 1.0;
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

    _previousLetter = widget.letter;

    if (widget.letter != oldWidget.letter) {
      if (widget.letter.isNotEmpty) {
        _controller.stop();
        _animateWithDebounce();
      } else {
        _controller.value = 0.0;
        _isAnimating = false;
      }
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
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    
    final border = widget.attempted
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
      borderRadius: const BorderRadius.all(Radius.circular(4)),
    );
    
    final displayLetter = widget.letter.isEmpty && _previousLetter.isNotEmpty && _isAnimating
        ? _previousLetter  // Keep showing previous letter during transition
        : widget.letter;

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
          decoration: decoration,
          child: Text(
            displayLetter.toUpperCase(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: widget.attempted ? Colors.white : onSurface,
            ),
          ),
        ),
      ),
    );
  }
}