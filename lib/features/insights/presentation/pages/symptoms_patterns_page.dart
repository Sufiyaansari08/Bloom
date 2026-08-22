import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';

class SymptomsPatternsPage extends StatefulWidget {
  const SymptomsPatternsPage({super.key});

  @override
  State<SymptomsPatternsPage> createState() => _SymptomsPatternsPageState();
}

class _SymptomsPatternsPageState extends State<SymptomsPatternsPage> {
  int _selectedCycles = 6;
  bool _showAllSymptoms = false;

  @override
  Widget build(BuildContext context) {
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
          'Symptoms Patterns',
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
                title: 'Symptoms & Patterns',
                description: 'See which symptoms you log most often and when they typically occur during your cycle.',
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

            // CARD 1: Most common symptoms
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
                    'Most common symptoms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCommonSymptomRow(Icons.face, 'Headache', 88),
                  const SizedBox(height: 16),
                  _buildCommonSymptomRow(Icons.waves, 'Cramps', 75),
                  const SizedBox(height: 16),
                  _buildCommonSymptomRow(Icons.bubble_chart, 'Bloating', 63),
                  const SizedBox(height: 16),
                  _buildCommonSymptomRow(Icons.battery_alert, 'Fatigue', 50),
                  const SizedBox(height: 16),
                  _buildCommonSymptomRow(Icons.face_retouching_natural, 'Acne', 38),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CARD 2: When symptoms usually occur
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
                    'When symptoms usually occur',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineSymptomRow(
                    Icons.face,
                    'Headache',
                    'Usually 1-2 days before your period',
                    'Before period',
                    AppColors.primaryPink,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineSymptomRow(
                    Icons.bubble_chart,
                    'Bloating',
                    'Usually 2-4 days before your period',
                    'Before period',
                    AppColors.primaryPink,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineSymptomRow(
                    Icons.waves,
                    'Cramps',
                    'Usually during the first 1-2 days of your period',
                    'During period',
                    AppColors.primaryPurple,
                  ),
                  if (_showAllSymptoms) ...[
                    const SizedBox(height: 24),
                    _buildTimelineSymptomRow(
                      Icons.battery_alert,
                      'Fatigue',
                      'Usually 1 day before your period',
                      'Before period',
                      AppColors.primaryPink,
                    ),
                    const SizedBox(height: 24),
                    _buildTimelineSymptomRow(
                      Icons.face_retouching_natural,
                      'Acne',
                      'Usually 3-5 days before your period',
                      'Before period',
                      AppColors.primaryPink,
                    ),
                    const SizedBox(height: 24),
                    _buildTimelineSymptomRow(
                      Icons.mood_bad,
                      'Mood Swings',
                      'Usually during the first 2 days of your period',
                      'During period',
                      AppColors.primaryPurple,
                    ),
                    const SizedBox(height: 24),
                    _buildTimelineSymptomRow(
                      Icons.girl,
                      'Tender Breasts',
                      'Usually 5-7 days before your period',
                      'Before period',
                      AppColors.primaryPink,
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _showAllSymptoms = !_showAllSymptoms;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        _showAllSymptoms ? 'Show less' : 'View all symptoms',
                        style: const TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildCommonSymptomRow(IconData icon, String label, int percentage) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '$percentage%',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSymptomRow(IconData icon, String title, String subtitle, String badgeText, Color badgeColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 20),
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
}
