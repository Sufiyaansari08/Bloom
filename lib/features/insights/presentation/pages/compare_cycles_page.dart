import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/info_dialog.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';

class CompareCyclesPage extends ConsumerStatefulWidget {
  const CompareCyclesPage({super.key});

  @override
  ConsumerState<CompareCyclesPage> createState() => _CompareCyclesPageState();
}

class _CompareCyclesPageState extends ConsumerState<CompareCyclesPage> {
  int _selectedTab = 0; // 0 = Current vs Previous, 1 = Select any cycles
  String? _customCycle1Id;
  String? _customCycle2Id;

  bool _isLogForCycle(DailyLog log, Cycle cycle) {
    if (log.cycleId != null && log.cycleId == cycle.id) return true;
    final logDate = DateTime(log.date.year, log.date.month, log.date.day);
    final startDate = DateTime(
      cycle.startDate.year,
      cycle.startDate.month,
      cycle.startDate.day,
    );
    final endDate = cycle.endDate != null
        ? DateTime(
            cycle.endDate!.year,
            cycle.endDate!.month,
            cycle.endDate!.day,
          )
        : startDate.add(Duration(days: (cycle.cycleLength ?? 28) - 1));
    return !logDate.isBefore(startDate) && !logDate.isAfter(endDate);
  }

  String _formatCycleDisplayName(Cycle c, int index, bool isCurrent) {
    final startStr = DateFormat('MMM d').format(c.startDate);
    if (c.endDate == null) {
      return isCurrent ? 'Current ($startStr - Present)' : 'Cycle $index ($startStr - Present)';
    } else {
      final endStr = DateFormat('MMM d').format(c.endDate!);
      return isCurrent ? 'Current ($startStr - $endStr)' : 'Cycle $index ($startStr - $endStr)';
    }
  }

  _CycleMetrics _calculateMetrics({
    required Cycle? cycle,
    required String defaultTitle,
    required List<DailyLog> allLogs,
    required List<DailySymptom> allSymptoms,
  }) {
    if (cycle == null) {
      return _CycleMetrics(
        title: defaultTitle,
        subtitle: '(No cycle recorded)',
        cycleLength: '--',
        periodLength: '--',
        averagePain: '--',
        headache: '--',
        bloating: '--',
        averageSleep: '--',
        stressLevel: '--',
      );
    }

    final startStr = DateFormat('MMM d').format(cycle.startDate);
    final String subtitle;
    if (cycle.endDate == null) {
      subtitle = '($startStr - Present)';
    } else {
      subtitle = '($startStr - ${DateFormat('MMM d').format(cycle.endDate!)})';
    }

    // Cycle length
    final String cycleLength;
    int? numericCycleLength;
    if (cycle.cycleLength != null && cycle.cycleLength! > 0) {
      cycleLength = '${cycle.cycleLength} days';
      numericCycleLength = cycle.cycleLength;
    } else if (cycle.endDate == null) {
      final days = DateTime.now().difference(cycle.startDate).inDays + 1;
      cycleLength = 'Day $days (ongoing)';
      numericCycleLength = days;
    } else {
      cycleLength = '--';
    }

    // Period length
    final String periodLength;
    if (cycle.periodLength != null && cycle.periodLength! > 0) {
      periodLength = '${cycle.periodLength} days';
    } else {
      periodLength = '--';
    }

    // Filter logs for this cycle
    final cycleLogs = allLogs.where((l) => _isLogForCycle(l, cycle)).toList();

    // Average pain
    final painLogs = cycleLogs.where((l) => l.painLevel != null && l.painLevel! > 0).toList();
    final String averagePain;
    double? numericPain;
    if (painLogs.isNotEmpty) {
      numericPain = painLogs.map((l) => l.painLevel!).reduce((a, b) => a + b) / painLogs.length;
      averagePain = '${numericPain.toStringAsFixed(1)} / 10';
    } else {
      averagePain = '--';
    }

    // Symptoms (Headache, Bloating)
    final cycleLogIds = cycleLogs.map((l) => l.id).toSet();
    final cycleSymptoms = allSymptoms
        .where((s) => !s.isDeleted && cycleLogIds.contains(s.dailyLogId))
        .map((s) => s.symptomName.toLowerCase())
        .toList();

    final String headache;
    if (cycleSymptoms.any((s) => s.contains('headache') || s.contains('migraine'))) {
      headache = 'Yes';
    } else if (cycleLogs.isNotEmpty) {
      headache = 'No';
    } else {
      headache = '--';
    }

    final String bloating;
    if (cycleSymptoms.any((s) => s.contains('bloat'))) {
      bloating = 'Yes';
    } else if (cycleLogs.isNotEmpty) {
      bloating = 'No';
    } else {
      bloating = '--';
    }

    // Average sleep
    final sleepLogs = cycleLogs.where((l) => l.sleepHours != null && l.sleepHours! > 0).toList();
    final String averageSleep;
    double? numericSleep;
    if (sleepLogs.isNotEmpty) {
      numericSleep = sleepLogs.map((l) => l.sleepHours!).reduce((a, b) => a + b) / sleepLogs.length;
      final h = numericSleep.floor();
      final m = ((numericSleep - h) * 60).round();
      averageSleep = m > 0 ? '${h}h ${m}m' : '${h}h';
    } else {
      averageSleep = '--';
    }

    // Stress level
    final stressLogs = cycleLogs.where((l) => l.stressLevel != null).toList();
    final String stressLevel;
    double? numericStress;
    if (stressLogs.isNotEmpty) {
      numericStress = stressLogs.map((l) => l.stressLevel!).reduce((a, b) => a + b) / stressLogs.length;
      stressLevel = '${numericStress.toStringAsFixed(1)} / 10';
    } else {
      stressLevel = '--';
    }

    return _CycleMetrics(
      title: defaultTitle,
      subtitle: subtitle,
      cycleLength: cycleLength,
      periodLength: periodLength,
      averagePain: averagePain,
      headache: headache,
      bloating: bloating,
      averageSleep: averageSleep,
      stressLevel: stressLevel,
      numericPain: numericPain,
      numericSleep: numericSleep,
      numericStress: numericStress,
      numericCycleLength: numericCycleLength,
    );
  }

  String _generateDifferenceText(_CycleMetrics m1, _CycleMetrics m2, Cycle? c1, Cycle? c2) {
    if (c1 == null || c2 == null) {
      return 'Track and complete your cycles to compare your symptoms, mood, and cycle lengths over time.';
    }

    final differences = <String>[];

    // Pain
    if (m1.numericPain != null && m2.numericPain != null) {
      final diff = m1.numericPain! - m2.numericPain!;
      if (diff.abs() >= 0.4) {
        differences.add(
          diff < 0
              ? 'average pain was lower (-${diff.abs().toStringAsFixed(1)})'
              : 'average pain was higher (+${diff.toStringAsFixed(1)})',
        );
      }
    }

    // Sleep
    if (m1.numericSleep != null && m2.numericSleep != null) {
      final diff = m1.numericSleep! - m2.numericSleep!;
      final mins = (diff.abs() * 60).round();
      if (mins >= 15) {
        differences.add(
          diff > 0
              ? 'sleep was longer (+${mins}m)'
              : 'sleep was shorter (-${mins}m)',
        );
      }
    }

    // Stress
    if (m1.numericStress != null && m2.numericStress != null) {
      final diff = m1.numericStress! - m2.numericStress!;
      if (diff.abs() >= 0.4) {
        differences.add(
          diff < 0
              ? 'stress level was lower'
              : 'stress level was higher',
        );
      }
    }

    // Cycle length
    if (m1.numericCycleLength != null && m2.numericCycleLength != null && c1.endDate != null) {
      final diff = m1.numericCycleLength! - m2.numericCycleLength!;
      if (diff.abs() >= 1) {
        differences.add(
          diff > 0
              ? 'cycle was ${diff.abs()} days longer'
              : 'cycle was ${diff.abs()} days shorter',
        );
      }
    }

    if (differences.isNotEmpty) {
      if (differences.length == 1) {
        return 'Your ${differences.first} in this cycle.';
      } else {
        return 'Your ${differences.sublist(0, differences.length - 1).join(', ')} and ${differences.last} in this cycle.';
      }
    }

    return 'Your cycle length, symptoms, and sleep remained consistent between these two cycles.';
  }

  Future<void> _showSelectCyclesDialog(List<Cycle> cycles) async {
    if (cycles.length < 2) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Compare Cycles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.text)),
          content: const Text(
            'You need at least 2 cycles recorded to compare selected cycles.',
            style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    String? temp1 = _customCycle1Id ?? cycles.last.id;
    String? temp2 = _customCycle2Id ?? cycles[cycles.length - 2].id;

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
                    items: List.generate(cycles.length, (index) {
                      final c = cycles[index];
                      final isLast = index == cycles.length - 1 && c.endDate == null;
                      final label = _formatCycleDisplayName(c, index + 1, isLast);
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(label, style: const TextStyle(fontSize: 13)),
                      );
                    }),
                    onChanged: (val) => setDialogState(() => temp1 = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: temp2,
                    decoration: InputDecoration(
                      labelText: 'Select Cycle 2',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: List.generate(cycles.length, (index) {
                      final c = cycles[index];
                      final isLast = index == cycles.length - 1 && c.endDate == null;
                      final label = _formatCycleDisplayName(c, index + 1, isLast);
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(label, style: const TextStyle(fontSize: 13)),
                      );
                    }),
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
      setState(() {
        _selectedTab = 1;
        _customCycle1Id = temp1;
        _customCycle2Id = temp2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cycles = ref.watch(allCyclesStreamProvider).value ?? [];
    final allLogs = ref.watch(allDailyLogsStreamProvider).value ?? [];
    final allSymptoms = ref.watch(allSymptomsStreamProvider).value ?? [];

    final activeCycles = cycles.where((c) => !c.isDeleted).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final validLogs = allLogs.where((l) => !l.isDeleted).toList();

    Cycle? cycle1;
    Cycle? cycle2;
    String cycle1Title = 'Current';
    String cycle2Title = 'Previous';

    if (_selectedTab == 0) {
      // Current cycle vs Previous cycle
      if (activeCycles.isNotEmpty) {
        cycle1 = activeCycles.last;
        cycle1Title = cycle1.endDate == null ? 'Current' : 'Latest';
        if (activeCycles.length >= 2) {
          cycle2 = activeCycles[activeCycles.length - 2];
          cycle2Title = 'Previous';
        }
      }
    } else {
      // Select any cycles
      if (activeCycles.isNotEmpty) {
        cycle1 = activeCycles.where((c) => c.id == _customCycle1Id).firstOrNull ?? activeCycles.last;
        final c1Idx = activeCycles.indexOf(cycle1);
        cycle1Title = cycle1.endDate == null ? 'Current' : 'Cycle ${c1Idx + 1}';

        if (activeCycles.length >= 2) {
          cycle2 = activeCycles.where((c) => c.id == _customCycle2Id).firstOrNull ??
              activeCycles[activeCycles.length - 2];
          final c2Idx = activeCycles.indexOf(cycle2);
          cycle2Title = cycle2.endDate == null ? 'Current' : 'Cycle ${c2Idx + 1}';
        }
      }
    }

    final m1 = _calculateMetrics(
      cycle: cycle1,
      defaultTitle: cycle1Title,
      allLogs: validLogs,
      allSymptoms: allSymptoms,
    );

    final m2 = _calculateMetrics(
      cycle: cycle2,
      defaultTitle: cycle2Title,
      allLogs: validLogs,
      allSymptoms: allSymptoms,
    );

    final differenceText = _generateDifferenceText(m1, m2, cycle1, cycle2);

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
                description:
                    'Compare your current cycle with past cycles to understand how your symptoms, mood, and cycle lengths change over time.',
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
                      onTap: () {
                        setState(() {
                          _selectedTab = 0;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 0
                              ? AppColors.primaryPurple.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Current cycle vs\nPrevious cycle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: _selectedTab == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedTab == 0
                                ? AppColors.primaryPurple
                                : AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showSelectCyclesDialog(activeCycles),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 1
                              ? AppColors.primaryPurple.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Select any cycles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: _selectedTab == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedTab == 1
                                ? AppColors.primaryPurple
                                : AppColors.secondaryText,
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
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              m1.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m1.subtitle,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                color: AppColors.secondaryText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              m2.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m2.subtitle,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                color: AppColors.secondaryText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 8),
                  // Table Rows
                  _buildTableRow('Cycle length', m1.cycleLength, m2.cycleLength),
                  _buildTableRow('Period length', m1.periodLength, m2.periodLength),
                  _buildTableRow('Average pain', m1.averagePain, m2.averagePain),
                  _buildTableRow('Headache', m1.headache, m2.headache),
                  _buildTableRow('Bloating', m1.bloating, m2.bloating),
                  _buildTableRow('Average sleep', m1.averageSleep, m2.averageSleep),
                  _buildTableRow('Stress level', m1.stressLevel, m2.stressLevel),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // What's different? Card
            Container(
              padding:
                  const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 0),
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
                      Padding(
                        padding: const EdgeInsets.only(right: 80.0),
                        child: Text(
                          differenceText,
                          style: const TextStyle(
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
                color: AppColors.text,
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
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleMetrics {
  final String title;
  final String subtitle;
  final String cycleLength;
  final String periodLength;
  final String averagePain;
  final String headache;
  final String bloating;
  final String averageSleep;
  final String stressLevel;
  final double? numericPain;
  final double? numericSleep;
  final double? numericStress;
  final int? numericCycleLength;

  const _CycleMetrics({
    required this.title,
    required this.subtitle,
    required this.cycleLength,
    required this.periodLength,
    required this.averagePain,
    required this.headache,
    required this.bloating,
    required this.averageSleep,
    required this.stressLevel,
    this.numericPain,
    this.numericSleep,
    this.numericStress,
    this.numericCycleLength,
  });
}
