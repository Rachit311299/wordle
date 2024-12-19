import 'package:flutter/material.dart';

class CustomToast extends StatefulWidget {
  final String message;
  final Color backgroundColor;

  const CustomToast({
    Key? key,
    required this.message,
    this.backgroundColor = Colors.green,
  }) : super(key: key);

  static void show(BuildContext context, String message,
      {Color backgroundColor = Colors.green}) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final toastWidth = 200.0; 
        final leftPosition = (screenWidth - toastWidth) / 2; 

        return Positioned(
          top: 100, 
          left: leftPosition,
          width: toastWidth,
          child: CustomToast(
            message: message,
            backgroundColor: backgroundColor,
          ),
        );
      },
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 6)).then((_) {
      overlayEntry.remove();
    });
  }

  @override
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

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

    _controller.forward(); // Start the fade-in

    // Fade out before removal
    Future.delayed(const Duration(seconds: 5, milliseconds: 500)).then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 250, // Fixed width for the toast
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
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
    );
  }
}
