import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';

class MoodTrendsPage extends StatefulWidget {
  const MoodTrendsPage({super.key});

  @override
  State<MoodTrendsPage> createState() => _MoodTrendsPageState();
}

class _MoodTrendsPageState extends State<MoodTrendsPage> {
  int _selectedCycles = 6;

  @override
  Widget build(BuildContext context) {
    final moodData = _getMoodData(_selectedCycles);

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
          'Mood Trends',
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
                title: 'Mood Trends',
                description: 'Track how your mood changes across your cycle to identify patterns and emotional shifts.',
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
            const SizedBox(height: 24),

            // CARD 1: Mood distribution
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
                    'Mood distribution',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 120,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              startDegreeOffset: 270,
                              sections: [
                                PieChartSectionData(
                                  value: moodData['great']!.toDouble(),
                                  color: AppColors.success, // Great
                                  radius: 16,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: moodData['good']!.toDouble(),
                                  color: Colors.blue, // Good
                                  radius: 16,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: moodData['okay']!.toDouble(),
                                  color: const Color(0xFFF4C059), // Okay
                                  radius: 16,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: moodData['not_great']!.toDouble(),
                                  color: AppColors.primaryPurple, // Not Great
                                  radius: 16,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: moodData['bad']!.toDouble(),
                                  color: AppColors.primaryPink, // Bad
                                  radius: 16,
                                  showTitle: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLegendRow('Great', '${moodData['great']}%', AppColors.success),
                            const SizedBox(height: 8),
                            _buildLegendRow('Good', '${moodData['good']}%', Colors.blue),
                            const SizedBox(height: 8),
                            _buildLegendRow('Okay', '${moodData['okay']}%', const Color(0xFFF4C059)),
                            const SizedBox(height: 8),
                            _buildLegendRow('Not Great', '${moodData['not_great']}%', AppColors.primaryPurple),
                            const SizedBox(height: 8),
                            _buildLegendRow('Bad', '${moodData['bad']}%', AppColors.primaryPink),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // CARD 2: Mood by cycle phase (average)
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
                    'Mood by cycle phase (average)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineMoodRow(
                    Icons.sentiment_dissatisfied,
                    'Not Great',
                    'Usually 3-5 days before your period',
                    'Before period',
                    AppColors.primaryPurple,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineMoodRow(
                    Icons.mood_bad,
                    'Bad',
                    'Usually during the first 1-2 days of your period',
                    'During period',
                    AppColors.primaryPink,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineMoodRow(
                    Icons.sentiment_very_satisfied,
                    'Great',
                    'Usually 2-5 days after your period',
                    'After period',
                    AppColors.success,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 3: Your insight
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your insight',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 110.0),
                        child: const Text(
                          'You tend to feel lower mood 1-2 days before your period.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0, // Sticks nicely to the bottom right of the card
                    child: Image.asset(
                      'assets/images/low_mood_avatar_white_edited.jpg',
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow(String label, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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

  Widget _buildTimelineMoodRow(IconData icon, String title, String subtitle, String badgeText, Color badgeColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: badgeColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badgeText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }

  Map<String, int> _getMoodData(int cycles) {
    switch (cycles) {
      case 3:
        return {'great': 30, 'good': 40, 'okay': 15, 'not_great': 10, 'bad': 5};
      case 4:
        return {'great': 20, 'good': 30, 'okay': 25, 'not_great': 15, 'bad': 10};
      case 5:
        return {'great': 40, 'good': 25, 'okay': 20, 'not_great': 10, 'bad': 5};
      case 6:
        return {'great': 25, 'good': 35, 'okay': 20, 'not_great': 12, 'bad': 8};
      case 7:
        return {'great': 15, 'good': 45, 'okay': 25, 'not_great': 10, 'bad': 5};
      case 8:
        return {'great': 35, 'good': 30, 'okay': 15, 'not_great': 12, 'bad': 8};
      default:
        return {'great': 25, 'good': 35, 'okay': 20, 'not_great': 12, 'bad': 8};
    }
  }
}
