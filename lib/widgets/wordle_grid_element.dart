import 'package:flutter/material.dart';

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
  String? _previousLetter;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.letter.isNotEmpty) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WordleGridElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.letter != oldWidget.letter) {
      if (widget.letter.isNotEmpty) {
        _controller.reset();
        _controller.forward();
      }
      _previousLetter = oldWidget.letter;
    }
    
    if (!oldWidget.attempted && widget.attempted) {
      _controller.reset();
      Future.delayed(Duration(milliseconds: widget.pos * 200), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  BoxBorder? getBorder() {
    if (!widget.attempted) {
      return Border.all(
        // Use theme colors for border
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
        width: 2
      );
    }
    return Border.all(color: Colors.transparent, width: 2);
  }

  Color getTextColor() {
    if (!widget.attempted) {
      // Use theme colors for text
      return Theme.of(context).colorScheme.onSurface;
    }
    return Colors.white; // Keep white for attempted letters as they'll be on colored backgrounds
  }

  Color getBackgroundColor() {
    if (widget.color != null) {
      return widget.color!;
    }
    // Use theme surface color for empty cells
    return Theme.of(context).colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.letter.isEmpty ? 1.0 : _scaleAnimation.value,
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: getBorder(),
              color: getBackgroundColor(),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Text(
              widget.letter.toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: getTextColor(),
              ),
            ),
          ),
        );
      },
    );
  }
}