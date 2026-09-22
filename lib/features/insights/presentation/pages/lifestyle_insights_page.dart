import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';

class LifestyleInsightsPage extends StatefulWidget {
  const LifestyleInsightsPage({super.key});

  @override
  State<LifestyleInsightsPage> createState() => _LifestyleInsightsPageState();
}

class _LifestyleInsightsPageState extends State<LifestyleInsightsPage> {
  int _selectedCycles = 6;

  @override
  Widget build(BuildContext context) {
    final dummyData = _getDummyData(_selectedCycles);

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
          'Lifestyle Insights',
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
                title: 'Lifestyle Insights',
                description: 'See how your sleep, hydration, and exercise habits correlate with your cycle phases.',
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
                    return [2, 3, 4, 5, 6, 7, 8].map((int value) {
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

            // CARD 1: Your averages
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
                    'Your averages',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildAverageRow(Icons.nights_stay_outlined, 'Sleep', dummyData['sleep']!, Colors.indigo),
                  const SizedBox(height: 20),
                  _buildAverageRow(Icons.local_drink_outlined, 'Water intake', dummyData['water']!, Colors.lightBlue),
                  const SizedBox(height: 20),
                  _buildAverageRow(Icons.directions_walk, 'Activity level', dummyData['activity']!, Colors.green),
                  const SizedBox(height: 20),
                  _buildAverageRow(Icons.sentiment_dissatisfied, 'Stress level', dummyData['stress']!, AppColors.primaryPink),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 2: Lifestyle & symptoms correlation
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Lifestyle & symptoms correlation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_outline, size: 12, color: AppColors.primaryPurple),
                            const SizedBox(width: 4),
                            const Text(
                              'Pro',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildCorrelationRow(
                    Icons.face,
                    'Sleep & Headaches',
                    'Less sleep days had more headaches',
                    AppColors.primaryPink,
                  ),
                  const SizedBox(height: 20),
                  _buildCorrelationRow(
                    Icons.psychology,
                    'Stress & Pain',
                    'Higher stress associated with higher pain',
                    Colors.orange,
                  ),
                  const SizedBox(height: 20),
                  _buildCorrelationRow(
                    Icons.bolt,
                    'Activity & Energy',
                    'More active days had higher energy',
                    Colors.teal,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Unlock Pro Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unlock with Bloom Pro',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'See how your lifestyle affects your symptoms and mood.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.diamond_outlined,
                        color: AppColors.primaryPurple,
                        size: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Upgrade Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                        ],
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

  Widget _buildAverageRow(IconData icon, String title, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildCorrelationRow(IconData icon, String title, String subtitle, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
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
        const SizedBox(width: 16),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Icon(Icons.lock_outline, color: AppColors.secondaryText, size: 16),
        ),
      ],
    );
  }

  Map<String, String> _getDummyData(int cycles) {
    switch (cycles) {
      case 2:
        return {'sleep': '7h 00m', 'water': '2.0 L', 'activity': 'Moderate', 'stress': '4.5 / 10'};
      case 3:
        return {'sleep': '7h 15m', 'water': '2.1 L', 'activity': 'High', 'stress': '4.1 / 10'};
      case 4:
        return {'sleep': '6h 30m', 'water': '1.5 L', 'activity': 'Low', 'stress': '6.5 / 10'};
      case 5:
        return {'sleep': '8h 05m', 'water': '2.5 L', 'activity': 'High', 'stress': '3.2 / 10'};
      case 6:
        return {'sleep': '6h 42m', 'water': '1.7 L', 'activity': 'Moderate', 'stress': '5.2 / 10'};
      case 7:
        return {'sleep': '7h 50m', 'water': '2.0 L', 'activity': 'Moderate', 'stress': '4.8 / 10'};
      case 8:
        return {'sleep': '6h 10m', 'water': '1.2 L', 'activity': 'Low', 'stress': '7.1 / 10'};
      default:
        return {'sleep': '6h 42m', 'water': '1.7 L', 'activity': 'Moderate', 'stress': '5.2 / 10'};
    }
  }
}
