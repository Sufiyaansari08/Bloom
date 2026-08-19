import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BloomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;

  const BloomSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 10,
    this.divisions = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.primaryPink,
        inactiveTrackColor: AppColors.lightPink,
        trackHeight: 4.0,
        thumbColor: AppColors.primaryPink,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayColor: AppColors.primaryPink.withValues(alpha: 0.2),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.0),
        activeTickMarkColor: Colors.white,
        inactiveTickMarkColor: AppColors.primaryPink.withValues(alpha: 0.5),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}
