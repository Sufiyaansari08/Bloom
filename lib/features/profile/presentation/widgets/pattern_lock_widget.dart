import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class PatternLockWidget extends StatefulWidget {
  final Function(List<int> pattern) onPatternComplete;
  final VoidCallback? onPatternStart;
  final bool isError;
  final double size;
  final Color activeColor;
  final Color errorColor;

  const PatternLockWidget({
    super.key,
    required this.onPatternComplete,
    this.onPatternStart,
    this.isError = false,
    this.size = 280.0,
    this.activeColor = AppColors.primaryPurple,
    this.errorColor = const Color(0xFFE53935),
  });

  @override
  State<PatternLockWidget> createState() => PatternLockWidgetState();
}

class PatternLockWidgetState extends State<PatternLockWidget> {
  final List<int> _selectedDots = [];
  Offset? _currentTouchPosition;

  void clearPattern() {
    setState(() {
      _selectedDots.clear();
      _currentTouchPosition = null;
    });
  }

  Offset _getDotCenter(int index, double dimension) {
    final col = index % 3;
    final row = index ~/ 3;
    final step = dimension / 3.0;
    return Offset(
      col * step + step / 2.0,
      row * step + step / 2.0,
    );
  }

  int? _findNearestDot(Offset localPos, double dimension) {
    const hitRadius = 38.0;
    for (int i = 0; i < 9; i++) {
      final center = _getDotCenter(i, dimension);
      if ((localPos - center).distance <= hitRadius) {
        return i;
      }
    }
    return null;
  }

  void _onPanStart(DragStartDetails details) {
    widget.onPatternStart?.call();
    setState(() {
      _selectedDots.clear();
      _currentTouchPosition = details.localPosition;
    });

    final dot = _findNearestDot(details.localPosition, widget.size);
    if (dot != null) {
      HapticFeedback.lightImpact();
      setState(() {
        _selectedDots.add(dot);
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentTouchPosition = details.localPosition;
    });

    final dot = _findNearestDot(details.localPosition, widget.size);
    if (dot != null && !_selectedDots.contains(dot)) {
      HapticFeedback.lightImpact();
      setState(() {
        _selectedDots.add(dot);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentTouchPosition = null;
    });

    if (_selectedDots.isNotEmpty) {
      widget.onPatternComplete(List.from(_selectedDots));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isError ? widget.errorColor : widget.activeColor;

    return Center(
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _PatternPainter(
              selectedDots: _selectedDots,
              currentTouchPos: _currentTouchPosition,
              color: color,
              isError: widget.isError,
            ),
          ),
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final List<int> selectedDots;
  final Offset? currentTouchPos;
  final Color color;
  final bool isError;

  _PatternPainter({
    required this.selectedDots,
    required this.currentTouchPos,
    required this.color,
    required this.isError,
  });

  Offset _dotCenter(int index, Size size) {
    final col = index % 3;
    final row = index ~/ 3;
    final step = size.width / 3.0;
    return Offset(
      col * step + step / 2.0,
      row * step + step / 2.0,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Draw connecting lines between already touched dots
    if (selectedDots.length > 1) {
      final path = Path();
      path.moveTo(
        _dotCenter(selectedDots.first, size).dx,
        _dotCenter(selectedDots.first, size).dy,
      );

      for (int i = 1; i < selectedDots.length; i++) {
        final pt = _dotCenter(selectedDots[i], size);
        path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // 2. Draw live line from last selected dot to current touch position
    if (selectedDots.isNotEmpty && currentTouchPos != null) {
      final lastDotCenter = _dotCenter(selectedDots.last, size);
      canvas.drawLine(lastDotCenter, currentTouchPos!, linePaint);
    }

    // 3. Draw all 9 dots
    for (int i = 0; i < 9; i++) {
      final center = _dotCenter(i, size);
      final isSelected = selectedDots.contains(i);

      if (isSelected) {
        // Outer glow halo
        final haloPaint = Paint()
          ..color = color.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, 22.0, haloPaint);

        // Ring border
        final ringPaint = Paint()
          ..color = color.withValues(alpha: 0.5)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(center, 14.0, ringPaint);

        // Solid inner core
        final corePaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, 7.0, corePaint);
      } else {
        // Inactive subtle dot
        final inactivePaint = Paint()
          ..color = AppColors.lightPurple.withValues(alpha: 0.9)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, 8.0, inactivePaint);

        final dotBorder = Paint()
          ..color = AppColors.border
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(center, 8.0, dotBorder);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) {
    return oldDelegate.selectedDots != selectedDots ||
        oldDelegate.currentTouchPos != currentTouchPos ||
        oldDelegate.color != color ||
        oldDelegate.isError != isError;
  }
}
