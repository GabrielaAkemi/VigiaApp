import 'dart:async';
import 'package:flutter/material.dart';

class NeonTypewriter extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;
  final Duration typingSpeed;
  final Duration pauseDuration;

  const NeonTypewriter({
    super.key,
    required this.texts,
    required this.style,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(milliseconds: 2000),
  });

  @override
  State<NeonTypewriter> createState() => _NeonTypewriterState();
}

class _NeonTypewriterState extends State<NeonTypewriter> {
  String _displayedText = "";
  int _currentTextIndex = 0;
  int _currentCharIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(widget.typingSpeed, (timer) {
      if (!mounted) return;

      final currentFullText = widget.texts[_currentTextIndex];

      setState(() {
        if (!_isDeleting) {
          // Digitando
          if (_currentCharIndex < currentFullText.length) {
            _currentCharIndex++;
            _displayedText = currentFullText.substring(0, _currentCharIndex);
          } else {
            // Pausa antes de apagar
            _timer?.cancel();
            Future.delayed(widget.pauseDuration, () {
              if (mounted) {
                _isDeleting = true;
                _startAnimation();
              }
            });
          }
        } else {
          if (_currentCharIndex > 0) {
            _currentCharIndex--;
            _displayedText = currentFullText.substring(0, _currentCharIndex);
          } else {
            _isDeleting = false;
            _currentTextIndex = (_currentTextIndex + 1) % widget.texts.length;
            _timer?.cancel();
            _startAnimation();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_displayedText, style: widget.style),
        // Cursor piscante
        _BlinkingCursor(style: widget.style),
      ],
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  final TextStyle style;
  const _BlinkingCursor({required this.style});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text("_", style: widget.style),
    );
  }
}