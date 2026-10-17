import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../../../core/database/database_providers.dart';

class DoctorReportSetupPage extends ConsumerStatefulWidget {
  const DoctorReportSetupPage({super.key});

  @override
  ConsumerState<DoctorReportSetupPage> createState() => _DoctorReportSetupPageState();
}

class _DoctorReportSetupPageState extends ConsumerState<DoctorReportSetupPage> {
  int? _selectedCycles;

  @override
  Widget build(BuildContext context) {
    final cycles = ref.watch(allCyclesStreamProvider).value ?? [];
    final activeCycles = cycles.where((c) => !c.isDeleted).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final completedCycles = activeCycles
        .where((c) => c.endDate != null && c.cycleLength != null && c.cycleLength! > 0)
        .toList();

    // Build dynamic options from database
    final Map<int, String> cycleOptions = {};
    if (completedCycles.isNotEmpty) {
      final maxAvailable = math.min(6, completedCycles.length);
      for (int count = 1; count <= maxAvailable; count++) {
        final sublist = completedCycles.sublist(completedCycles.length - count);
        final start = sublist.first.startDate;
        final end = sublist.last.endDate ??
            sublist.last.startDate.add(
              Duration(days: sublist.last.cycleLength ?? 28),
            );
        final dateLabel = '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, yyyy').format(end)}';
        if (count == 1) {
          cycleOptions[count] = 'Last cycle ($dateLabel)';
        } else {
          cycleOptions[count] = 'Last $count cycles ($dateLabel)';
        }
      }
    } else if (activeCycles.isNotEmpty) {
      final start = activeCycles.last.startDate;
      cycleOptions[1] = 'Current cycle (started ${DateFormat('MMM d, yyyy').format(start)})';
    } else {
      cycleOptions[1] = 'Baseline profile (1 cycle)';
    }

    // Default to the max available option (e.g. 6 or total completed)
    if (_selectedCycles == null || !cycleOptions.containsKey(_selectedCycles)) {
      _selectedCycles = cycleOptions.keys.last;
    }

    final selectedLabel = cycleOptions[_selectedCycles] ?? '';

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
                title: 'Doctor Report Setup',
                description: 'Select the cycles you want to include in your doctor report and choose which sections of your health data to share.',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24.0,
          24.0,
          24.0,
          100.0,
        ), // Padding for bottom nav
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Your health\nsummary, ready\nfor your doctor.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                height: 1.3,
                              ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Get a detailed report of your cycles, symptoms, lifestyle and mood patterns.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.text,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/images/doctor_avatar_2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Select Time Range
            const Text(
              'Select time range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: PopupMenuButton<int>(
                initialValue: _selectedCycles,
                position: PopupMenuPosition.under,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                offset: const Offset(0, 10),
                onSelected: (int value) {
                  setState(() {
                    _selectedCycles = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return cycleOptions.entries.map((entry) {
                    return PopupMenuItem<int>(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.text,
                        ),
                      ),
                    );
                  }).toList();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Report Includes
            const Text(
              'Report includes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildCheckListItem('Cycle summary', isLast: false),
                  _buildCheckListItem('Period details', isLast: false),
                  _buildCheckListItem('Symptoms & patterns', isLast: false),
                  _buildCheckListItem('Lifestyle & mood trends', isLast: false),
                  _buildCheckListItem('Notes & observations', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Generate Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/doctor_report/result?cycles=$_selectedCycles');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Generate Report',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Privacy Notice
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: AppColors.primaryPurple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Your data is private & secure',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Only you and your doctor will have access.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckListItem(String text, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 16,
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: AppColors.primaryPink,
            size: 20,
          ),
        ],
      ),
    );
  }
}
