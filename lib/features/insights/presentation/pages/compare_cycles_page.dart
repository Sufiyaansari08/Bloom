import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';

class CompareCyclesPage extends StatefulWidget {
  const CompareCyclesPage({super.key});

  @override
  State<CompareCyclesPage> createState() => _CompareCyclesPageState();
}

class _CompareCyclesPageState extends State<CompareCyclesPage> {
  int _selectedTab = 0; // 0 = Current vs Previous, 1 = Select any cycles

  String _col1Title = 'Current';
  String _col1Subtitle = '(May 24 - -)';
  String _col2Title = 'Previous';
  String _col2Subtitle = '(Apr 25 - May 23)';

  List<String> _col1Data = ['29 days', '5 days', '5 / 10', 'Yes', 'Yes', '6h 30m', '5 / 10'];
  List<String> _col2Data = ['31 days', '5 days', '7 / 10', 'Yes', 'No', '7h 10m', '4 / 10'];

  List<String> get _availableCycles => [
    'Cycle 1 (May 24 - -)',
    'Cycle 2 (Apr 25 - May 23)',
    'Cycle 3 (Mar 27 - Apr 24)',
    'Cycle 4 (Feb 26 - Mar 26)',
    'Cycle 5 (Jan 28 - Feb 25)',
    'Cycle 6 (Dec 30 - Jan 27)',
    'Cycle 7 (Dec 01 - Dec 29)',
    'Cycle 8 (Nov 02 - Nov 30)',
  ];

  void _resetToCurrentVsPrevious() {
    setState(() {
      _selectedTab = 0;
      _col1Title = 'Current';
      _col1Subtitle = '(May 24 - -)';
      _col2Title = 'Previous';
      _col2Subtitle = '(Apr 25 - May 23)';
      _col1Data = ['29 days', '5 days', '5 / 10', 'Yes', 'Yes', '6h 30m', '5 / 10'];
      _col2Data = ['31 days', '5 days', '7 / 10', 'Yes', 'No', '7h 10m', '4 / 10'];
    });
  }

  Future<void> _showSelectCyclesDialog() async {
    String? temp1 = _availableCycles[2];
    String? temp2 = _availableCycles[3];

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Compare Cycles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.text)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: temp1,
                    decoration: InputDecoration(
                      labelText: 'Select Cycle 1',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _availableCycles.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (val) => setDialogState(() => temp1 = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: temp2,
                    decoration: InputDecoration(
                      labelText: 'Select Cycle 2',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _availableCycles.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (val) => setDialogState(() => temp2 = val),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Proceed'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && temp1 != null && temp2 != null) {
      List<String> parseCycle(String cycleString) {
        final parts = cycleString.split(' (');
        if (parts.length > 1) {
          return [parts[0], '(${parts[1]}'];
        }
        return [cycleString, ''];
      }

      final c1 = parseCycle(temp1!);
      final c2 = parseCycle(temp2!);

      setState(() {
        _selectedTab = 1;
        _col1Title = c1[0];
        _col1Subtitle = c1[1];
        _col2Title = c2[0];
        _col2Subtitle = c2[1];
        // Generate dummy data based on selection
        _col1Data = ['28 days', '6 days', '3 / 10', 'No', 'No', '8h 15m', '2 / 10'];
        _col2Data = ['30 days', '4 days', '6 / 10', 'Yes', 'Yes', '6h 45m', '6 / 10'];
      });
    }
  }

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
          'Compare Cycles',
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
                title: 'Compare Cycles',
                description: 'Compare your current cycle with past cycles to understand how your symptoms, mood, and cycle lengths change over time.',
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
            // Toggle Switch
            Container(
              height: 56,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _resetToCurrentVsPrevious,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? AppColors.primaryPurple.withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Current cycle vs\nPrevious cycle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                            color: _selectedTab == 0 ? AppColors.primaryPurple : AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _showSelectCyclesDialog,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? AppColors.primaryPurple.withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Select any cycles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                            color: _selectedTab == 1 ? AppColors.primaryPurple : AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),


            // Comparison Summary Card
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
                    'Comparison summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Table Header
                  Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: SizedBox(), // Empty top-left cell
                      ),
                      Expanded(
                        flex: 4,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$_col1Title\n',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                  height: 1.5,
                                ),
                              ),
                              TextSpan(
                                text: _col1Subtitle,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$_col2Title\n',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                  height: 1.5,
                                ),
                              ),
                              TextSpan(
                                text: _col2Subtitle,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 8),
                  // Table Rows
                  _buildTableRow('Cycle length', _col1Data[0], _col2Data[0]),
                  _buildTableRow('Period length', _col1Data[1], _col2Data[1]),
                  _buildTableRow('Average pain', _col1Data[2], _col2Data[2]),
                  _buildTableRow('Headache', _col1Data[3], _col2Data[3]),
                  _buildTableRow('Bloating', _col1Data[4], _col2Data[4]),
                  _buildTableRow('Average sleep', _col1Data[5], _col2Data[5]),
                  _buildTableRow('Stress level', _col1Data[6], _col2Data[6]),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // What's different? Card
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What's different?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 80.0),
                        child: Text(
                          'Your average pain is lower and stress level is higher in this cycle.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: -20,
                        child: Image.asset(
                          'assets/images/cycle_card_illustration.png',
                          height: 80,
                        ),
                      ),
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

  Widget _buildTableRow(String label, String currentVal, String previousVal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.text, // Kept slightly darker for label readability
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              currentVal,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              previousVal,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText, // Previous val is faded
              ),
            ),
          ),
        ],
      ),
    );
  }
}
