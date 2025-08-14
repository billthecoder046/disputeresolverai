import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotOne;
  late Animation<double> _dotTwo;
  late Animation<double> _dotThree;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();

    _dotOne = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );
    _dotTwo = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );
    _dotThree = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            width: 6,
            height: 6 + animation.value,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Typing",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),
        _buildDot(_dotOne),
        _buildDot(_dotTwo),
        _buildDot(_dotThree),
      ],
    );
  }
}
