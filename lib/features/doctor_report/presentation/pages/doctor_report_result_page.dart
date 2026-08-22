import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:printing/printing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../services/pdf_generator_service.dart';

class DoctorReportResultPage extends StatelessWidget {
  const DoctorReportResultPage({super.key});

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
          'Doctor Report',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: AppColors.text,
            ),
            onPressed: () {
              showPageInfoDialog(
                context,
                title: 'Doctor Report',
                description: 'This is your generated health report. It summarizes your cycle lengths, symptoms, and lifestyle trends for you to share with your healthcare provider.',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cover Page (Panel 6)

            // Top Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.local_florist,
                              color: AppColors.primaryPink,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Bloom',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPink,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Doctor Report',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                height: 1.3,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Feb 1 – Jul 31, 2026 (6 cycles)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/images/doctor_avatar_2.png',
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Patient Information Card
            _buildWhiteCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildInfoCol('Name', 'Ananya Sharma'),
                      ),
                      Expanded(flex: 3, child: _buildInfoCol('Age', '24')),
                      Expanded(
                        flex: 4,
                        child: _buildInfoCol('Date of Birth', '12 Jan 2002'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildInfoCol('Height', '165 cm'),
                      ),
                      Expanded(
                        flex: 3,
                        child: _buildInfoCol('Weight', '60 kg'),
                      ),
                      Expanded(
                        flex: 4,
                        child: _buildInfoCol('Blood Group', 'O+'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Report Overview Card
            _buildWhiteCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This report contains your menstrual cycle, symptoms, lifestyle and mood data for the selected time range.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildMetricBox(
                            '29',
                            'days',
                            'Avg. cycle length',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricBox(
                            '5',
                            'days',
                            'Avg. period length',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricBox(
                            '28-31',
                            'days',
                            'Cycle range',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // What's included Card
            _buildWhiteCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What's included",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildChecklistItem('Cycle summary'),
                  _buildChecklistItem('Period details'),
                  _buildChecklistItem('Symptoms & patterns'),
                  _buildChecklistItem('Lifestyle & mood trends'),
                  _buildChecklistItem('Notes & observations'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 1. CYCLE SUMMARY
            _buildSectionTitle('Cycle Summary'),
            const SizedBox(height: 16),
            // Average Cycle Length Bar Chart
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
                    'Average cycle length',
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
                    children: const [
                      Text(
                        '29',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'days',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 150,
                    child: BarChart(
                      BarChartData(
                        minY: 0,
                        maxY: 35,
                        gridData: const FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 7,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 7,
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
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => AppColors.primaryPurple,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toInt()} days',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        barGroups: List.generate(6, (index) {
                          final data = [28.0, 30.0, 29.0, 31.0, 30.0, 29.0];
                          return _buildBarData(index + 1, data[index]);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 3 Small Stat Boxes
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildMetricBox(
                      '28',
                      'days',
                      'Shortest cycle',
                      isHorizontal: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox(
                      '31',
                      'days',
                      'Longest cycle',
                      isHorizontal: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox(
                      '5',
                      'days',
                      'Average period',
                      isHorizontal: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Cycle Variation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Cycle variation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '±2',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'days',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your cycles are fairly consistent.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 8,
                          color: AppColors.border,
                        ),
                        CircularProgressIndicator(
                          value: 0.8,
                          strokeWidth: 8,
                          color: AppColors.primaryPurple,
                          strokeCap: StrokeCap.round,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // PERIOD DETAILS
            _buildSectionTitle('Period Details'),
            const SizedBox(height: 16),
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
                    'Period length over time',
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
                    children: const [
                      Text(
                        '5',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'days avg',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 150,
                    child: BarChart(
                      BarChartData(
                        minY: 0,
                        maxY: 10,
                        gridData: const FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 2,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
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
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => AppColors.primaryPurple,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toInt()} days',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        barGroups: List.generate(6, (index) {
                          final data = [4.0, 5.0, 5.0, 6.0, 4.0, 5.0];
                          return _buildPeriodBarData(index + 1, data[index]);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Period Stat Boxes
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildMetricBox(
                      '4',
                      'days',
                      'Shortest period',
                      bgColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                      isHorizontal: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox(
                      '6',
                      'days',
                      'Longest period',
                      bgColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                      isHorizontal: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox(
                      '6',
                      '/10',
                      'Moderate pain',
                      bgColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                      isHorizontal: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. SYMPTOMS PATTERNS
            _buildSectionTitle('Symptoms Patterns'),
            const SizedBox(height: 16),
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
                  _buildTimelineRow(
                    Icons.face,
                    'Headache',
                    'Usually 1-2 days before your period',
                    'Before period',
                    AppColors.primaryPink,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineRow(
                    Icons.bubble_chart,
                    'Bloating',
                    'Usually 2-4 days before your period',
                    'Before period',
                    AppColors.primaryPink,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineRow(
                    Icons.waves,
                    'Cramps',
                    'Usually during the first 1-2 days of your period',
                    'During period',
                    AppColors.primaryPurple,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineRow(
                    Icons.mood_bad,
                    'Mood Swings',
                    'Usually during the first 2 days of your period',
                    'During period',
                    AppColors.primaryPurple,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 3. MOOD TRENDS
            _buildSectionTitle('Mood Trends'),
            const SizedBox(height: 16),
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
                  _buildTimelineRow(
                    Icons.sentiment_dissatisfied,
                    'Not Great',
                    'Usually 3-5 days before your period',
                    'Before period',
                    AppColors.primaryPurple,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineRow(
                    Icons.mood_bad,
                    'Bad',
                    'Usually during the first 1-2 days of your period',
                    'During period',
                    AppColors.primaryPink,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineRow(
                    Icons.sentiment_very_satisfied,
                    'Great',
                    'Usually 2-5 days after your period',
                    'After period',
                    AppColors.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 4. LIFESTYLE AVERAGES
            _buildSectionTitle('Lifestyle Insights'),
            const SizedBox(height: 16),
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
                  _buildAverageRow(
                    Icons.nights_stay_outlined,
                    'Sleep',
                    '6.5 hrs',
                    Colors.indigo,
                  ),
                  const SizedBox(height: 20),
                  _buildAverageRow(
                    Icons.local_drink_outlined,
                    'Water intake',
                    '1.5 L',
                    Colors.lightBlue,
                  ),
                  const SizedBox(height: 20),
                  _buildAverageRow(
                    Icons.directions_walk,
                    'Activity level',
                    'Moderate',
                    Colors.green,
                  ),
                  const SizedBox(height: 20),
                  _buildAverageRow(
                    Icons.sentiment_dissatisfied,
                    'Stress level',
                    'High',
                    AppColors.primaryPink,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // 5. OBSERVATIONS
            _buildSectionTitle('Observations'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryPink.withValues(alpha: 0.15),
                    AppColors.primaryPurple.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: AppColors.primaryPurple,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Your body summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Based on your data, your cycle is fairly regular with an average length of 29 days. You tend to experience moderate pain and mood swings primarily during the first few days of your period. High stress levels have been noted recently, which may affect your overall energy and sleep quality.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Export Buttons (Moved to bottom)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final bytes = await PdfGeneratorService.generateDoctorReport();
                  await Printing.sharePdf(bytes: bytes, filename: 'bloom_doctor_report.pdf');
                },
                icon: const Icon(Icons.ios_share, color: Colors.white),
                label: const Text(
                  'Share with Doctor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final bytes = await PdfGeneratorService.generateDoctorReport();
                  await Printing.layoutPdf(
                    onLayout: (format) async => bytes,
                    name: 'bloom_doctor_report.pdf',
                  );
                },
                icon: const Icon(
                  Icons.file_download_outlined,
                  color: AppColors.primaryPurple,
                ),
                label: const Text(
                  'Download PDF',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100), // padding for bottom nav
          ],
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
    );
  }

  BarChartGroupData _buildBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primaryPink,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  BarChartGroupData _buildPeriodBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primaryPurple,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildTimelineRow(
    IconData icon,
    String title,
    String subtitle,
    String phase,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      phase,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAverageRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
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

  Widget _buildInfoCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 4),
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

  Widget _buildMetricBox(
    String value,
    String unit,
    String label, {
    Color? bgColor,
    bool isHorizontal = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.primaryPink.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isHorizontal)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                if (unit.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
              ],
            )
          else ...[
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            if (unit.isNotEmpty)
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
          ],
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primaryPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.text),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
