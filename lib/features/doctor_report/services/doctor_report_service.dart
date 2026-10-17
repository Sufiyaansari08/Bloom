import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';

class CycleChartPoint {
  final int index;
  final String label;
  final int length;

  const CycleChartPoint({
    required this.index,
    required this.label,
    required this.length,
  });
}

class ReportSymptomPattern {
  final String name;
  final String subtitle;
  final String phase;
  final IconData icon;
  final Color color;

  const ReportSymptomPattern({
    required this.name,
    required this.subtitle,
    required this.phase,
    required this.icon,
    required this.color,
  });
}

class ReportMoodTrend {
  final String mood;
  final String subtitle;
  final String phase;
  final IconData icon;
  final Color color;

  const ReportMoodTrend({
    required this.mood,
    required this.subtitle,
    required this.phase,
    required this.icon,
    required this.color,
  });
}

class DoctorReportData {
  final String userName;
  final String userAge;
  final String userDob;
  final String userHeight;
  final String userWeight;
  final String userBloodGroup;
  final String dateRangeText;
  final int cycleCount;
  final int avgCycleLength;
  final int avgPeriodLength;
  final int shortestCycle;
  final int longestCycle;
  final String cycleRange;
  final int cycleVariationDays;
  final String variationText;
  final List<CycleChartPoint> cycleBarPoints;
  final int shortestPeriod;
  final int longestPeriod;
  final List<CycleChartPoint> periodBarPoints;
  final double? avgPainLevel;
  final String painLabel;
  final String painLevelText;
  final List<ReportSymptomPattern> symptomPatterns;
  final List<ReportMoodTrend> moodTrends;
  final String sleepFormatted;
  final String waterFormatted;
  final String activityFormatted;
  final String stressFormatted;
  final String observationsSummary;

  const DoctorReportData({
    required this.userName,
    required this.userAge,
    required this.userDob,
    required this.userHeight,
    required this.userWeight,
    required this.userBloodGroup,
    required this.dateRangeText,
    required this.cycleCount,
    required this.avgCycleLength,
    required this.avgPeriodLength,
    required this.shortestCycle,
    required this.longestCycle,
    required this.cycleRange,
    required this.cycleVariationDays,
    required this.variationText,
    required this.cycleBarPoints,
    required this.shortestPeriod,
    required this.longestPeriod,
    required this.periodBarPoints,
    required this.avgPainLevel,
    required this.painLabel,
    required this.painLevelText,
    required this.symptomPatterns,
    required this.moodTrends,
    required this.sleepFormatted,
    required this.waterFormatted,
    required this.activityFormatted,
    required this.stressFormatted,
    required this.observationsSummary,
  });
}

class DoctorReportService {
  DoctorReportService._();

  static bool isLogForCycle(DailyLog log, Cycle cycle) {
    if (log.cycleId != null && log.cycleId == cycle.id) return true;
    final logDate = DateTime(log.date.year, log.date.month, log.date.day);
    final startDate = DateTime(
      cycle.startDate.year,
      cycle.startDate.month,
      cycle.startDate.day,
    );
    if (logDate.isBefore(startDate)) return false;
    if (cycle.endDate != null) {
      final endDate = DateTime(
        cycle.endDate!.year,
        cycle.endDate!.month,
        cycle.endDate!.day,
      );
      return !logDate.isAfter(endDate);
    }
    return true;
  }

  static double? parseWaterLiters(String? raw) {
    if (raw == null || raw.isEmpty || raw == 'Select') return null;
    if (raw.contains('< 1.0') || raw.contains('<1.0')) return 0.8;
    if (raw.contains('1.5')) return 1.5;
    if (raw.contains('2.0')) return 2.0;
    if (raw.contains('2.5')) return 2.5;
    if (raw.contains('> 3.0') || raw.contains('>3.0')) return 3.2;
    final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(raw);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }

  static IconData getSymptomIcon(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('cramp')) return Icons.waves;
    if (lower.contains('headache') || lower.contains('migraine')) return Icons.face;
    if (lower.contains('bloat')) return Icons.bubble_chart;
    if (lower.contains('fatigue') || lower.contains('tired')) return Icons.battery_alert;
    if (lower.contains('mood')) return Icons.mood_bad;
    if (lower.contains('acne') || lower.contains('skin')) return Icons.face_retouching_natural;
    if (lower.contains('nausea')) return Icons.sick;
    if (lower.contains('back')) return Icons.accessibility_new;
    if (lower.contains('breast') || lower.contains('tender')) return Icons.woman;
    if (lower.contains('sleep') || lower.contains('insomnia')) return Icons.bedtime;
    if (lower.contains('dizz')) return Icons.rotate_right;
    if (lower.contains('crav')) return Icons.restaurant;
    if (lower.contains('digest')) return Icons.spa;
    return Icons.healing;
  }

  static DoctorReportData computeReportData({
    required UserProfile? user,
    required List<Cycle> allCycles,
    required List<DailyLog> allLogs,
    required List<DailySymptom> allSymptoms,
    int requestedCycleCount = 6,
  }) {
    // 1. Patient Info
    final userName = user?.name.isNotEmpty == true ? user!.name : 'Guest';
    String userAge = '-';
    String userDob = '-';
    if (user?.dateOfBirth != null) {
      final dob = user!.dateOfBirth!;
      userDob = DateFormat('d MMM yyyy').format(dob);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      userAge = age > 0 ? '$age' : '-';
    }

    final userHeight = (user?.heightCm != null && user!.heightCm! > 0)
        ? '${user.heightCm!.toInt()} cm'
        : '-';
    final userWeight = (user?.weightKg != null && user!.weightKg! > 0)
        ? '${user.weightKg!.toInt()} kg'
        : '-';

    final rawBg = user?.bloodGroup?.trim();
    final String userBloodGroup;
    if (rawBg == null ||
        rawBg.isEmpty ||
        rawBg.toLowerCase().contains("don't know") ||
        rawBg.toLowerCase().contains("dont know") ||
        rawBg == '-') {
      userBloodGroup = '-';
    } else {
      userBloodGroup = rawBg;
    }

    // 2. Filter targeted cycles
    final activeCycles = allCycles.where((c) => !c.isDeleted).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final completedCycles = activeCycles
        .where((c) => c.endDate != null && c.cycleLength != null && c.cycleLength! > 0)
        .toList();

    final List<Cycle> targetedCycles;
    if (completedCycles.isNotEmpty) {
      final count = math.min(requestedCycleCount, completedCycles.length);
      targetedCycles = completedCycles.sublist(completedCycles.length - count);
    } else if (activeCycles.isNotEmpty) {
      targetedCycles = [activeCycles.last];
    } else {
      targetedCycles = [];
    }

    // 3. Date range text
    final String dateRangeText;
    if (targetedCycles.isNotEmpty) {
      final start = targetedCycles.first.startDate;
      final end = targetedCycles.last.endDate ??
          targetedCycles.last.startDate.add(
            Duration(days: targetedCycles.last.cycleLength ?? user?.avgCycleLength ?? 28),
          );
      final count = targetedCycles.length;
      final cycleLabel = count == 1 ? 'cycle' : 'cycles';
      dateRangeText = '${DateFormat('MMM d').format(start)} – ${DateFormat('MMM d, yyyy').format(end)} ($count $cycleLabel)';
    } else {
      dateRangeText = 'Baseline profile (${user?.avgCycleLength ?? 28} days cycle)';
    }

    // 4. Cycle length metrics
    final int avgCycleLength;
    final int shortestCycle;
    final int longestCycle;
    final int cycleVariationDays;
    final String variationText;
    final List<CycleChartPoint> cycleBarPoints = [];

    final validCycleLengths = targetedCycles
        .where((c) => c.cycleLength != null && c.cycleLength! > 0)
        .map((c) => c.cycleLength!)
        .toList();

    if (validCycleLengths.isNotEmpty) {
      avgCycleLength = (validCycleLengths.reduce((a, b) => a + b) / validCycleLengths.length).round();
      shortestCycle = validCycleLengths.reduce(math.min);
      longestCycle = validCycleLengths.reduce(math.max);
      cycleVariationDays = ((longestCycle - shortestCycle) / 2).round();

      for (int i = 0; i < targetedCycles.length; i++) {
        final c = targetedCycles[i];
        final length = (c.cycleLength != null && c.cycleLength! > 0) ? c.cycleLength! : avgCycleLength;
        cycleBarPoints.add(CycleChartPoint(index: i + 1, label: 'C${i + 1}', length: length));
      }
    } else {
      avgCycleLength = user?.avgCycleLength ?? 29;
      shortestCycle = avgCycleLength;
      longestCycle = avgCycleLength;
      cycleVariationDays = 0;
      cycleBarPoints.add(CycleChartPoint(index: 1, label: 'C1', length: avgCycleLength));
    }

    final cycleRange = (shortestCycle == longestCycle)
        ? '$avgCycleLength'
        : '$shortestCycle-$longestCycle';

    if (cycleVariationDays <= 1) {
      variationText = 'Your cycles are very consistent.';
    } else if (cycleVariationDays <= 3) {
      variationText = 'Your cycles are fairly consistent.';
    } else {
      variationText = 'Your cycles show noticeable variation.';
    }

    // 5. Period length metrics
    final int avgPeriodLength;
    final int shortestPeriod;
    final int longestPeriod;
    final List<CycleChartPoint> periodBarPoints = [];

    final validPeriodLengths = targetedCycles
        .where((c) => c.periodLength != null && c.periodLength! > 0)
        .map((c) => c.periodLength!)
        .toList();

    if (validPeriodLengths.isNotEmpty) {
      avgPeriodLength = (validPeriodLengths.reduce((a, b) => a + b) / validPeriodLengths.length).round();
      shortestPeriod = validPeriodLengths.reduce(math.min);
      longestPeriod = validPeriodLengths.reduce(math.max);

      for (int i = 0; i < targetedCycles.length; i++) {
        final c = targetedCycles[i];
        final pLength = (c.periodLength != null && c.periodLength! > 0) ? c.periodLength! : avgPeriodLength;
        periodBarPoints.add(CycleChartPoint(index: i + 1, label: 'C${i + 1}', length: pLength));
      }
    } else {
      avgPeriodLength = user?.avgPeriodLength ?? 5;
      shortestPeriod = avgPeriodLength;
      longestPeriod = avgPeriodLength;
      periodBarPoints.add(CycleChartPoint(index: 1, label: 'C1', length: avgPeriodLength));
    }

    // 6. Relevant daily logs
    final relevantLogs = targetedCycles.isNotEmpty
        ? allLogs.where((l) => !l.isDeleted && targetedCycles.any((c) => isLogForCycle(l, c))).toList()
        : allLogs.where((l) => !l.isDeleted).toList();

    final Map<String, DailyLog> logsById = {for (final l in relevantLogs) l.id: l};

    // 7. Pain metrics
    final painLevels = relevantLogs
        .where((l) => l.painLevel != null && l.painLevel! > 0)
        .map((l) => l.painLevel!)
        .toList();

    final double? avgPainLevel = painLevels.isNotEmpty
        ? (painLevels.reduce((a, b) => a + b) / painLevels.length)
        : null;

    final String painLabel;
    final String painLevelText;
    if (avgPainLevel == null) {
      painLabel = 'No pain logged';
      painLevelText = '--';
    } else if (avgPainLevel <= 3.5) {
      painLabel = 'Mild pain';
      painLevelText = '${avgPainLevel.round()}/10';
    } else if (avgPainLevel <= 6.5) {
      painLabel = 'Moderate pain';
      painLevelText = '${avgPainLevel.round()}/10';
    } else {
      painLabel = 'Severe pain';
      painLevelText = '${avgPainLevel.round()}/10';
    }

    // 8. Symptoms patterns
    final relevantSymptoms = allSymptoms.where((s) => !s.isDeleted && logsById.containsKey(s.dailyLogId)).toList();
    final Map<String, List<DailySymptom>> symptomsByName = {};
    for (final s in relevantSymptoms) {
      final name = s.symptomName.trim();
      if (name.isEmpty) continue;
      symptomsByName.putIfAbsent(name, () => []).add(s);
    }

    final List<ReportSymptomPattern> symptomPatterns = [];
    final sortedSymptomEntries = symptomsByName.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    for (final entry in sortedSymptomEntries.take(5)) {
      final name = entry.key;
      final instances = entry.value;

      // Determine most common timing
      int duringPeriod = 0;
      int beforePeriod = 0;
      int ovulation = 0;
      int afterPeriod = 0;

      for (final s in instances) {
        final log = logsById[s.dailyLogId];
        if (log == null) continue;
        Cycle? matchedCycle;
        for (final c in targetedCycles) {
          if (isLogForCycle(log, c)) {
            matchedCycle = c;
            break;
          }
        }
        if (matchedCycle != null) {
          final dayInCycle = log.date.difference(matchedCycle.startDate).inDays + 1;
          final pLen = matchedCycle.periodLength ?? avgPeriodLength;
          final cLen = matchedCycle.cycleLength ?? avgCycleLength;
          if (dayInCycle >= 1 && dayInCycle <= pLen) {
            duringPeriod++;
          } else if (dayInCycle > cLen - 4) {
            beforePeriod++;
          } else if (dayInCycle >= (cLen - 16) && dayInCycle <= (cLen - 12)) {
            ovulation++;
          } else {
            afterPeriod++;
          }
        } else {
          duringPeriod++;
        }
      }

      String phase;
      String subtitle;
      Color color;

      if (duringPeriod >= beforePeriod && duringPeriod >= ovulation && duringPeriod >= afterPeriod) {
        phase = 'During period';
        subtitle = 'Usually during the first 1-2 days of your period';
        color = AppColors.primaryPurple;
      } else if (beforePeriod >= ovulation && beforePeriod >= afterPeriod) {
        phase = 'Before period';
        subtitle = 'Usually 1-3 days before your period';
        color = AppColors.primaryPink;
      } else if (ovulation >= afterPeriod) {
        phase = 'Ovulation';
        subtitle = 'Usually mid-cycle around ovulation';
        color = Colors.deepPurple;
      } else {
        phase = 'After period';
        subtitle = 'Usually 2-5 days after your period';
        color = Colors.teal;
      }

      symptomPatterns.add(ReportSymptomPattern(
        name: name,
        subtitle: subtitle,
        phase: phase,
        icon: getSymptomIcon(name),
        color: color,
      ));
    }

    // 9. Mood trends
    final moodLogs = relevantLogs.where((l) => l.mood != null && l.mood!.trim().isNotEmpty && l.mood != 'none').toList();
    final Map<String, int> moodCounts = {};
    for (final l in moodLogs) {
      final m = l.mood!.trim();
      moodCounts[m] = (moodCounts[m] ?? 0) + 1;
    }

    final List<ReportMoodTrend> moodTrends = [];
    final sortedMoods = moodCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedMoods.take(4)) {
      final rawMood = entry.key;
      final lower = rawMood.toLowerCase();

      String moodDisplay;
      IconData icon;
      Color color;
      String phase;
      String subtitle;

      if (lower.contains('not') || lower.contains('not great') || lower.contains('notgreat')) {
        moodDisplay = 'Not Great';
        icon = Icons.sentiment_dissatisfied;
        color = AppColors.primaryPurple;
        phase = 'Before period';
        subtitle = 'Usually 3-5 days before your period';
      } else if (lower.contains('great')) {
        moodDisplay = 'Great';
        icon = Icons.sentiment_very_satisfied;
        color = AppColors.success;
        phase = 'After period';
        subtitle = 'Usually 2-5 days after your period';
      } else if (lower.contains('bad')) {
        moodDisplay = 'Bad';
        icon = Icons.mood_bad;
        color = AppColors.primaryPink;
        phase = 'During period';
        subtitle = 'Usually during the first 1-2 days of your period';
      } else {
        moodDisplay = rawMood[0].toUpperCase() + rawMood.substring(1);
        icon = Icons.sentiment_neutral;
        color = const Color(0xFFF4C059);
        phase = 'Mid cycle';
        subtitle = 'Logged across steady cycle days';
      }

      moodTrends.add(ReportMoodTrend(
        mood: moodDisplay,
        subtitle: subtitle,
        phase: phase,
        icon: icon,
        color: color,
      ));
    }

    // 10. Lifestyle averages
    final sleepValues = relevantLogs
        .where((l) => l.sleepHours != null && l.sleepHours! > 0)
        .map((l) => l.sleepHours!)
        .toList();
    final double? avgSleep = sleepValues.isNotEmpty
        ? (sleepValues.reduce((a, b) => a + b) / sleepValues.length)
        : null;
    final sleepFormatted = avgSleep != null ? '${avgSleep.toStringAsFixed(1)} hrs' : 'No data';

    final waterValues = relevantLogs
        .map((l) => parseWaterLiters(l.waterIntake))
        .whereType<double>()
        .toList();
    final double? avgWater = waterValues.isNotEmpty
        ? (waterValues.reduce((a, b) => a + b) / waterValues.length)
        : null;
    final waterFormatted = avgWater != null ? '${avgWater.toStringAsFixed(1)} L' : 'No data';

    final activities = relevantLogs
        .where((l) => l.activityLevel != null && l.activityLevel!.isNotEmpty && l.activityLevel != 'Select')
        .map((l) => l.activityLevel!)
        .toList();
    final Map<String, int> actCounts = {};
    for (final a in activities) {
      actCounts[a] = (actCounts[a] ?? 0) + 1;
    }
    String activityFormatted = 'Moderate';
    if (actCounts.isNotEmpty) {
      activityFormatted = actCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    } else if (relevantLogs.isEmpty) {
      activityFormatted = 'No data';
    }

    final stressValues = relevantLogs
        .where((l) => l.stressLevel != null && l.stressLevel! > 0)
        .map((l) => l.stressLevel!)
        .toList();
    final double? avgStress = stressValues.isNotEmpty
        ? (stressValues.reduce((a, b) => a + b) / stressValues.length)
        : null;
    final String stressFormatted;
    if (avgStress == null) {
      stressFormatted = relevantLogs.isEmpty ? 'No data' : 'Moderate';
    } else if (avgStress <= 3.5) {
      stressFormatted = 'Low';
    } else if (avgStress <= 6.5) {
      stressFormatted = 'Moderate';
    } else {
      stressFormatted = 'High';
    }

    // 11. Observations summary paragraph
    final buffer = StringBuffer();
    if (targetedCycles.isNotEmpty) {
      buffer.write(
        'Based on your data over ${targetedCycles.length} ${targetedCycles.length == 1 ? 'cycle' : 'cycles'}, '
        'your cycle is ${variationText.toLowerCase().replaceAll('your cycles are ', '').replaceAll('your cycles show ', '')} '
        'with an average length of $avgCycleLength days (variation ±$cycleVariationDays days). ',
      );
    } else {
      buffer.write(
        'Based on your onboarding profile, your baseline cycle length is $avgCycleLength days. ',
      );
    }

    if (avgPainLevel != null && avgPainLevel > 0) {
      buffer.write(
        'You tend to experience ${painLabel.toLowerCase()} primarily during the first few days of your period. ',
      );
    } else {
      buffer.write(
        'No significant pain or cramping discomfort was logged during this time window. ',
      );
    }

    if (avgSleep != null || stressFormatted != 'No data') {
      final sleepText = avgSleep != null ? '$sleepFormatted of sleep' : 'steady sleep';
      final stressText = stressFormatted != 'No data' ? '$stressFormatted stress levels' : 'balanced stress';
      buffer.write(
        'Lifestyle records indicate $sleepText and $stressText, which contribute to your overall monthly well-being.',
      );
    }

    final observationsSummary = buffer.toString().trim();

    return DoctorReportData(
      userName: userName,
      userAge: userAge,
      userDob: userDob,
      userHeight: userHeight,
      userWeight: userWeight,
      userBloodGroup: userBloodGroup,
      dateRangeText: dateRangeText,
      cycleCount: targetedCycles.length,
      avgCycleLength: avgCycleLength,
      avgPeriodLength: avgPeriodLength,
      shortestCycle: shortestCycle,
      longestCycle: longestCycle,
      cycleRange: cycleRange,
      cycleVariationDays: cycleVariationDays,
      variationText: variationText,
      cycleBarPoints: cycleBarPoints,
      shortestPeriod: shortestPeriod,
      longestPeriod: longestPeriod,
      periodBarPoints: periodBarPoints,
      avgPainLevel: avgPainLevel,
      painLabel: painLabel,
      painLevelText: painLevelText,
      symptomPatterns: symptomPatterns,
      moodTrends: moodTrends,
      sleepFormatted: sleepFormatted,
      waterFormatted: waterFormatted,
      activityFormatted: activityFormatted,
      stressFormatted: stressFormatted,
      observationsSummary: observationsSummary,
    );
  }
}
