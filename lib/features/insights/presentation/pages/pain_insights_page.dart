import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';

class PainInsightsPage extends StatefulWidget {
  const PainInsightsPage({super.key});

  @override
  State<PainInsightsPage> createState() => _PainInsightsPageState();
}

class _PainInsightsPageState extends State<PainInsightsPage> {
  int _selectedCycles = 6;
  final List<double> _allDummyPainValues = [5.6, 6.2, 4.8, 8.0, 5.0, 4.2, 7.1, 5.5];

  @override
  Widget build(BuildContext context) {
    final currentData = _allDummyPainValues.take(_selectedCycles).toList();
    final averagePain = (currentData.reduce((a, b) => a + b) / currentData.length).toStringAsFixed(1);
    
    // Find min and max
    double minPain = currentData[0];
    double maxPain = currentData[0];
    int maxCycleIndex = 1;
    int minCycleIndex = 1;
    for (int i = 0; i < currentData.length; i++) {
      if (currentData[i] > maxPain) {
        maxPain = currentData[i];
        maxCycleIndex = i + 1;
      }
      if (currentData[i] < minPain) {
        minPain = currentData[i];
        minCycleIndex = i + 1;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Pain Insights',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.text),
            onPressed: () {
              showPageInfoDialog(
                context,
                title: 'Pain Insights',
                description: 'Analyze your pain levels to understand severity and duration throughout your cycle phases.',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: PopupMenuButton<int>(
                  initialValue: _selectedCycles,
                  position: PopupMenuPosition.under,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onSelected: (int newValue) {
                    setState(() {
                      _selectedCycles = newValue;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return [3, 4, 5, 6, 7, 8].map((int value) {
                      return PopupMenuItem<int>(
                        value: value,
                        child: Text(
                          'Last $value cycles',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Last $_selectedCycles cycles',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryPurple,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CARD 1: Average pain score with Line Chart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Average pain score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        averagePain,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '/ 10',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPainCategoryColor(double.parse(averagePain)).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getPainCategoryText(double.parse(averagePain)),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPainCategoryColor(double.parse(averagePain)),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 150,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 2,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.border,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 2,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 8,
                                  child: Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 8,
                                  child: Text(
                                    'C${value.toInt()}',
                                    style: const TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 1,
                        maxX: _selectedCycles.toDouble(),
                        minY: 0,
                        maxY: 10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(_selectedCycles, (index) {
                              return FlSpot((index + 1).toDouble(), currentData[index]);
                            }),
                            isCurved: true,
                            color: AppColors.primaryPink,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.primaryPink,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.primaryPink.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // ROW 2: 3 Small Stat Boxes
            Row(
              children: [
                _buildSmallStatBox('Highest pain', maxPain.toStringAsFixed(1), 'Cycle $maxCycleIndex'),
                const SizedBox(width: 8),
                _buildSmallStatBox('Lowest pain', minPain.toStringAsFixed(1), 'Cycle $minCycleIndex'),
                const SizedBox(width: 8),
                _buildSmallStatBox('Most painful', 'Day 1', 'of period'),
              ],
            ),
            
            const SizedBox(height: 16),

            // CARD 2: Pain by phase (average)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pain by phase (average)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPhasePainRow('Before period', 6.4),
                  const SizedBox(height: 16),
                  _buildPhasePainRow('During period', 8.1),
                  const SizedBox(height: 16),
                  _buildPhasePainRow('After period', 3.2),
                  const SizedBox(height: 16),
                  _buildPhasePainRow('Ovulation time', 2.8),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 3: Pain intensity distribution
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pain intensity distribution',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Stacked Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Expanded(flex: 30, child: Container(height: 16, color: AppColors.success)),
                        Expanded(flex: 45, child: Container(height: 16, color: const Color(0xFFF4C059))),
                        Expanded(flex: 20, child: Container(height: 16, color: AppColors.primaryPurple)),
                        Expanded(flex: 5, child: Container(height: 16, color: AppColors.primaryPink)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendItem('Mild', '30%', AppColors.success),
                      _buildLegendItem('Moderate', '45%', const Color(0xFFF4C059)),
                      _buildLegendItem('Severe', '20%', AppColors.primaryPurple),
                      _buildLegendItem('V.Severe', '5%', AppColors.primaryPink),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPainCategoryColor(double score) {
    if (score <= 3.0) return AppColors.success;
    if (score <= 6.0) return const Color(0xFFF4C059);
    if (score <= 8.0) return AppColors.primaryPurple;
    return AppColors.primaryPink;
  }

  String _getPainCategoryText(double score) {
    if (score <= 3.0) return 'Mild';
    if (score <= 6.0) return 'Moderate';
    if (score <= 8.0) return 'Severe';
    return 'Very Severe';
  }

  Widget _buildSmallStatBox(String title, String value, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhasePainRow(String label, double score) {
    final color = _getPainCategoryColor(score);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: score / 10.0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            score.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}
