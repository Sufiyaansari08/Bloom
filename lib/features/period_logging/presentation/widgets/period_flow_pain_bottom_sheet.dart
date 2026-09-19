import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_slider.dart';

class PeriodFlowPainResult {
  final String flow;
  final int painLevel;

  const PeriodFlowPainResult({
    required this.flow,
    required this.painLevel,
  });
}

/// Helper function to open the multi-step bottom sheet and handle database saving.
Future<void> showPeriodFlowPainSheet({
  required BuildContext context,
  required WidgetRef ref,
  required DateTime date,
  int? cycleDay,
  bool showDisclaimer = false,
  String? initialFlow,
  int? initialPain,
}) async {
  final cleanDate = DateTime(date.year, date.month, date.day);

  final result = await showModalBottomSheet<PeriodFlowPainResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => PeriodFlowPainBottomSheetContent(
      date: cleanDate,
      cycleDay: cycleDay,
      showDisclaimer: showDisclaimer,
      initialFlow: initialFlow,
      initialPain: initialPain,
    ),
  );

  if (result == null || !context.mounted) return;

  // Persist flow & pain to database
  final user = ref.read(userProfileStreamProvider).value;
  final dailyLogRepo = ref.read(dailyLogRepositoryProvider);
  final cycleRepo = ref.read(cycleRepositoryProvider);
  final cycleId = await cycleRepo.getOrCreateCycleForPeriodDate(
    cleanDate,
    avgCycleLength: user?.avgCycleLength,
    avgPeriodLength: user?.avgPeriodLength,
    userId: user?.id,
  );

  final existingLog = await dailyLogRepo.getLogForDate(cleanDate);
  final logId = existingLog?.id ?? '${cleanDate.millisecondsSinceEpoch}_log';

  await dailyLogRepo.upsertDailyLog(
    DailyLogsCompanion(
      id: drift.Value(logId),
      userId: drift.Value(user?.id ?? existingLog?.userId ?? 'default_user'),
      cycleId: drift.Value(cycleId),
      date: drift.Value(cleanDate),
      flowIntensity: drift.Value(result.flow),
      painLevel: drift.Value(result.painLevel),
      mood: existingLog?.mood != null ? drift.Value(existingLog!.mood) : const drift.Value.absent(),
      sleepHours: existingLog?.sleepHours != null ? drift.Value(existingLog!.sleepHours) : const drift.Value.absent(),
      waterIntake: existingLog?.waterIntake != null ? drift.Value(existingLog!.waterIntake) : const drift.Value.absent(),
      stressLevel: existingLog?.stressLevel != null ? drift.Value(existingLog!.stressLevel) : const drift.Value.absent(),
      activityLevel: existingLog?.activityLevel != null ? drift.Value(existingLog!.activityLevel) : const drift.Value.absent(),
      remedies: existingLog?.remedies != null ? drift.Value(existingLog!.remedies) : const drift.Value.absent(),
      painAfter1Hr: existingLog?.painAfter1Hr != null ? drift.Value(existingLog!.painAfter1Hr) : const drift.Value.absent(),
      notes: existingLog?.notes != null ? drift.Value(existingLog!.notes) : const drift.Value.absent(),
      updatedAt: drift.Value(DateTime.now()),
    ),
  );

  if (context.mounted) {
    final label = cycleDay != null
        ? 'Day $cycleDay'
        : DateFormat('MMM d').format(cleanDate);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Period logged for $label • ${result.flow} flow, Pain ${result.painLevel}/10'),
        backgroundColor: AppColors.primaryPink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class PeriodFlowPainBottomSheetContent extends StatefulWidget {
  final DateTime date;
  final int? cycleDay;
  final bool showDisclaimer;
  final String? initialFlow;
  final int? initialPain;

  const PeriodFlowPainBottomSheetContent({
    super.key,
    required this.date,
    this.cycleDay,
    this.showDisclaimer = false,
    this.initialFlow,
    this.initialPain,
  });

  @override
  State<PeriodFlowPainBottomSheetContent> createState() =>
      _PeriodFlowPainBottomSheetContentState();
}

class _PeriodFlowPainBottomSheetContentState
    extends State<PeriodFlowPainBottomSheetContent> {
  int _currentStep = 1; // 1 = Flow, 2 = Pain
  String? _selectedFlow;
  double _painLevel = 5.0;

  static const List<Map<String, dynamic>> _flowOptions = [
    {
      'label': 'Spotting',
      'description': 'Very light, occasional drops',
      'opacity': 0.25,
    },
    {
      'label': 'Light',
      'description': 'Light bleeding, minimal protection needed',
      'opacity': 0.45,
    },
    {
      'label': 'Medium',
      'description': 'Normal, moderate steady flow',
      'opacity': 0.65,
    },
    {
      'label': 'Heavy',
      'description': 'Heavy flow, frequent changes needed',
      'opacity': 0.85,
    },
    {
      'label': 'Very heavy',
      'description': 'Excessive flow or large clots',
      'opacity': 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedFlow = widget.initialFlow;
    if (widget.initialPain != null) {
      _painLevel = widget.initialPain!.toDouble();
    }
  }

  String _getPainLabel(int pain) {
    if (pain == 0) return 'No pain';
    if (pain <= 3) return 'Mild discomfort / light cramps';
    if (pain <= 6) return 'Moderate cramps';
    if (pain <= 8) return 'Severe pain / intense cramps';
    return 'Very severe / debilitating';
  }

  Color _getPainColor(int pain) {
    if (pain == 0) return AppColors.success;
    if (pain <= 3) return Colors.amber.shade700;
    if (pain <= 6) return AppColors.primaryPink;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(widget.date, DateTime.now());
    final dayLabel = widget.cycleDay != null
        ? 'Day ${widget.cycleDay}'
        : (isToday ? 'Today' : DateFormat('MMM d').format(widget.date));

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _currentStep == 1
                ? _buildFlowStep(context, dayLabel)
                : _buildPainStep(context, dayLabel),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowStep(BuildContext context, String dayLabel) {
    return Column(
      key: const ValueKey(1),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Title row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Log Period Flow',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Step 1 of 2 • $dayLabel',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.secondaryText),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),

        // Disclaimer for Home page
        if (widget.showDisclaimer) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: AppColors.primaryPurple),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 12, color: AppColors.text, height: 1.3),
                      children: [
                        const TextSpan(text: 'Logging period for '),
                        const TextSpan(
                          text: 'today',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: '. To log for any other day, please use the '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              context.go('/calendar');
                            },
                            child: const Text(
                              'Calendar page',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPurple,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
        // Flow Options List
        ..._flowOptions.map((opt) {
          final label = opt['label'] as String;
          final desc = opt['description'] as String;
          final opacity = opt['opacity'] as double;
          final isSelected = _selectedFlow == label;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFlow = label;
                  _currentStep = 2; // Move to pain slider step!
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.lightPink : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryPink
                        : Colors.grey.shade200,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: opacity.clamp(0.15, 1.0)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.water_drop,
                        color: opacity > 0.6 ? Colors.white : AppColors.primaryPink,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primaryPink : AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            desc,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: isSelected ? AppColors.primaryPink : AppColors.secondaryText,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPainStep(BuildContext context, String dayLabel) {
    final int painInt = _painLevel.toInt();

    return Column(
      key: const ValueKey(2),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Title row with Back button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.text),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _currentStep = 1;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rate Your Pain',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Step 2 of 2 • $dayLabel',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.secondaryText),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Selected flow badge with edit action
        GestureDetector(
          onTap: () {
            setState(() {
              _currentStep = 1;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.lightPink,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop, size: 16, color: AppColors.primaryPink),
                const SizedBox(width: 6),
                Text(
                  'Flow: ${_selectedFlow ?? "Selected"}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryPink),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Pain level rating number and label
        Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$painInt',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _getPainColor(painInt),
                    ),
                  ),
                  const Text(
                    ' / 10',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getPainLabel(painInt),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getPainColor(painInt),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Slider
        BloomSlider(
          value: _painLevel,
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: (val) {
            setState(() {
              _painLevel = val;
            });
          },
        ),

        // Scale indicators
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('0 (None)', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
              Text('5 (Moderate)', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
              Text('10 (Severe)', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Save Button
        BloomButton(
          text: 'Save Period Log',
          backgroundColor: AppColors.primaryPink,
          onPressed: () {
            Navigator.of(context).pop(
              PeriodFlowPainResult(
                flow: _selectedFlow ?? 'Medium',
                painLevel: _painLevel.toInt(),
              ),
            );
          },
        ),
      ],
    );
  }
}
