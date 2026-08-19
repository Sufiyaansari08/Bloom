import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';

class CycleLengthChart extends StatelessWidget {
  const CycleLengthChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 40,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  );
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = 'Jan';
                      break;
                    case 1:
                      text = 'Feb';
                      break;
                    case 2:
                      text = 'Mar';
                      break;
                    case 3:
                      text = 'Apr';
                      break;
                    case 4:
                      text = 'May';
                      break;
                    default:
                      text = '';
                      break;
                  }
                  return SideTitleWidget(
                    meta: meta,
                    space: 4,
                    child: Text(text, style: style),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.border,
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 35,
                color: Colors.green.withValues(alpha: 0.5),
                strokeWidth: 2,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 5, bottom: 5),
                  style: const TextStyle(color: Colors.green, fontSize: 10),
                  labelResolver: (line) => 'Normal range',
                ),
              ),
              HorizontalLine(
                y: 21,
                color: Colors.green.withValues(alpha: 0.5),
                strokeWidth: 2,
                dashArray: [5, 5],
              ),
            ],
          ),
          barGroups: [
            _buildBarGroup(0, 28),
            _buildBarGroup(1, 29),
            _buildBarGroup(2, 27),
            _buildBarGroup(3, 30),
            _buildBarGroup(4, 28),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primaryPurple,
          width: 16,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 40,
            color: AppColors.background,
          ),
        ),
      ],
    );
  }
}
