import 'package:flutter/material.dart';
import 'dart:collection';

class CustomToast extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final bool shake;
  final Duration duration;
  final int position;

  const CustomToast({
    Key? key,
    required this.message,
    this.backgroundColor = Colors.green,
    this.shake = false,
    this.duration = const Duration(seconds: 6),
    required this.position,
  }) : super(key: key);

  static final Queue<_ToastEntry> _toastQueue = Queue<_ToastEntry>();
  
  static void _repositionAllToasts() {
    int index = 0;
    for (final entry in _toastQueue) {
      entry.updatePosition(index);
      index++;
    }
  }

  static void show(BuildContext context, String message,
      {Color backgroundColor = Colors.green, bool shake = false, Duration duration = const Duration(seconds: 6)}) {
    final overlay = Overlay.of(context);
    
    final toastEntry = _ToastEntry(
      position: 0,
      message: message,
      backgroundColor: backgroundColor,
      shake: shake,
      duration: duration,
    );
    
    _toastQueue.addFirst(toastEntry);
    
    overlay.insert(toastEntry.overlayEntry);
    
    _repositionAllToasts();
    
    Future.delayed(duration).then((_) {
      if (toastEntry.overlayEntry.mounted) {
        toastEntry.overlayEntry.remove();
      }
      
      _toastQueue.remove(toastEntry);
      
     
      _repositionAllToasts();
    });
  }

  @override
  _CustomToastState createState() => _CustomToastState();
}

class _ToastEntry {
  late final OverlayEntry overlayEntry;
  int position;
  final String message;
  final Color backgroundColor;
  final bool shake;
  final Duration duration;
  
  _ToastEntry({
    required this.position,
    required this.message,
    required this.backgroundColor,
    required this.shake,
    required this.duration,
  }) {
    // Create the overlay entry with a reference to this object
    overlayEntry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final toastWidth = 250.0;
        final leftPosition = (screenWidth - toastWidth) / 2;
        
        return Positioned(
          top: 100.0 + (position * 70.0),
          left: leftPosition,
          width: toastWidth,
          child: CustomToast(
            message: message,
            backgroundColor: backgroundColor,
            shake: shake,
            duration: duration,
            position: position,
          ),
        );
      },
    );
  }
  
  void updatePosition(int newPosition) {
    position = newPosition;
    overlayEntry.markNeedsBuild();
  }
}

class _CustomToastState extends State<CustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );


    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 3, end: -3), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -3, end: 2), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 2, end: -2), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -2, end: 1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1, end: -1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -1, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut), 
    ));

    _controller.value = 1.0;
    

    if (widget.shake) {
      _controller.forward(from: 0.0);
    }

 
    Future.delayed(widget.duration - const Duration(milliseconds: 500)).then((_) {
      if (mounted) {
        _controller.reverse(); 
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double opacity = widget.shake ? 
            (_controller.status == AnimationStatus.reverse ? _fadeAnimation.value : 1.0) : 
            _fadeAnimation.value;
            
        return Transform.translate(
          offset: Offset(widget.shake ? _shakeAnimation.value : 0, 0),
          child: Opacity(
            opacity: opacity,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 250,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: widget.backgroundColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}