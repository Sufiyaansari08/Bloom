import 'dart:math' as math;

/// Dedicated AI Insight Service for Bloom.
/// Supports both On-Device Dynamic Generation (100% offline, privacy-first)
/// and Cloud AI routing when enabled.
class AiInsightService {
  AiInsightService._();
  static final AiInsightService instance = AiInsightService._();

  // ==========================================================================
  // 1. HOME DASHBOARD: "Your body today"
  // ==========================================================================
  String getBodyTodayInsight({
    required int cycleDay,
    required int avgCycleLength,
    required int avgPeriodLength,
    required bool isPeriodOngoing,
    required bool isPeriodLate,
    int? painLevel,
    String? mood,
    double? sleepHours,
    int? symptomsCount,
    bool isPersonalizedEnabled = true,
  }) {
    // Determine cycle milestones
    final ovulationDay = math.max(1, avgCycleLength - 14);
    final fertileStart = math.max(avgPeriodLength + 1, ovulationDay - 4);
    final fertileEnd = ovulationDay + 2;

    // When personalized recommendations are disabled: brief, clean status
    if (!isPersonalizedEnabled) {
      if (isPeriodLate) {
        return 'Your cycle is running longer than usual. Stay hydrated and rest.';
      }
      if (isPeriodOngoing || cycleDay <= avgPeriodLength) {
        return 'You are in your period phase. Prioritize rest and hydration.';
      }
      if (cycleDay < fertileStart) {
        return 'You are in your follicular phase. Natural energy is rising.';
      }
      if (cycleDay <= fertileEnd) {
        return 'You are in your fertile window. Vitality and stamina are high.';
      }
      return 'You are in your luteal phase. Focus on calming, restorative routines.';
    }

    // Dynamic On-Device Generator: friendly, short 1-2 sentence insights
    if (isPeriodLate) {
      return 'Your period is running a few days late. Variations are common—stay hydrated and take it easy.';
    }

    // Menstrual Phase
    if (isPeriodOngoing || cycleDay <= avgPeriodLength) {
      if (painLevel != null && painLevel >= 4) {
        return 'You might feel more cramping today. A warm compress and resting can bring quick relief.';
      }
      if (sleepHours != null && sleepHours < 6.5) {
        return 'Your energy might dip today during your period. An early night and warm meals will help.';
      }
      return 'Your body is naturally renewing itself. Take things easy and stay cozy today.';
    }

    // Follicular Phase (Post-period to fertile window)
    if (cycleDay < fertileStart) {
      if (mood == 'Great' || mood == 'Good') {
        return 'Your natural energy and focus are climbing. A wonderful time to be active!';
      }
      return 'Estrogen is steadily rising, bringing higher stamina and a boost in mental clarity.';
    }

    // Ovulatory Window
    if (cycleDay <= fertileEnd) {
      if (cycleDay == ovulationDay) {
        return 'Your vitality and confidence tend to peak right around ovulation today.';
      }
      return 'You might feel a pleasant burst of energy and a natural glow during this window.';
    }

    // Luteal Phase (Post-ovulation to next period)
    final daysUntilNext = avgCycleLength - cycleDay;

    // Late Luteal (Pre-menstrual, 1-4 days before period)
    if (daysUntilNext <= 4) {
      if (painLevel != null && painLevel >= 3) {
        return 'Mild bloating or pre-period cramps are common now. A warm bath can help soothe.';
      }
      if (mood == 'Not great' || mood == 'Bad' || mood == 'Irritable') {
        return 'You might feel more sensitive or tired before your period. Be gentle with yourself today.';
      }
      return 'Your body is preparing for the next cycle. Enjoy calm routines and comforting meals.';
    }

    // Early / Mid Luteal
    if (sleepHours != null && sleepHours >= 7.5) {
      return 'Your restful sleep helps keep your mood calm and balanced during this phase.';
    }
    return 'Progesterone is steady, making this a calm and focused phase for everyday routines.';
  }

  // ==========================================================================
  // 2. CYCLE PATTERNS PAGE: "About your cycles"
  // ==========================================================================
  String getCyclePatternInsight({
    required int completedCyclesCount,
    required int averageCycle,
    required int shortestCycle,
    required int longestCycle,
    required int variation,
    required int averagePeriod,
    bool isPersonalizedEnabled = true,
  }) {
    if (!isPersonalizedEnabled) {
      if (completedCyclesCount == 0) {
        return 'Baseline: $averageCycle days cycle, $averagePeriod days period.';
      }
      return 'Average: $averageCycle days across $completedCyclesCount cycle(s) (±$variation days).';
    }

    if (completedCyclesCount == 0) {
      return 'Your baseline cycle is $averageCycle days. Log cycles to reveal personal patterns.';
    }

    if (completedCyclesCount == 1) {
      return 'You have 1 cycle recorded ($averageCycle days). Continued tracking will reveal your monthly rhythm.';
    }

    if (variation <= 2) {
      return 'Your cycle length is very regular and consistent, averaging $averageCycle days.';
    } else if (variation <= 5) {
      return 'Your cycle length is fairly stable, averaging $averageCycle days with normal shifts of ±$variation days.';
    } else {
      return 'Your cycle length varies from month to month, averaging $averageCycle days.';
    }
  }

  // ==========================================================================
  // 3. MOOD TRENDS PAGE: "Your insight"
  // ==========================================================================
  String getMoodTrendInsight({
    required int totalMoods,
    required String? beforePeriodPredominant,
    required String? duringPeriodPredominant,
    required String? afterPeriodPredominant,
    required String? ovulationPredominant,
    required Map<String, int> moodCounts,
    bool isPersonalizedEnabled = true,
  }) {
    if (totalMoods == 0) {
      return 'Keep logging your daily mood to discover personalized emotional patterns across your cycle.';
    }

    final isBeforeLow =
        beforePeriodPredominant == 'Not great' || beforePeriodPredominant == 'Bad';
    final isBeforeHigh =
        beforePeriodPredominant == 'Great' || beforePeriodPredominant == 'Good';
    final isDuringLow =
        duringPeriodPredominant == 'Not great' || duringPeriodPredominant == 'Bad';

    if (isBeforeLow) {
      return 'You tend to feel lower mood before your period.';
    }

    if (isBeforeHigh) {
      return 'Your mood tends to stay positive and resilient before your period.';
    }

    if (isDuringLow) {
      return 'You tend to feel lower mood during your period.';
    }

    if (ovulationPredominant == 'Great' || ovulationPredominant == 'Good') {
      return 'Your mood peaks around ovulation with higher energy.';
    }

    if (afterPeriodPredominant == 'Great' || afterPeriodPredominant == 'Good') {
      return 'Your mood steadily improves in the days after your period.';
    }

    return 'Your mood seems balanced throughout your cycles. Continued logging will reveal deeper patterns.';
  }

  // ==========================================================================
  // 4. LIFESTYLE PAGE: "Lifestyle & symptoms correlation"
  // ==========================================================================
  String getLifestyleCorrelationInsight({
    required double? avgSleep,
    required String? avgWater,
    required String? avgActivity,
    required int? avgStress,
    required bool hasCorrelations,
    bool isPersonalizedEnabled = true,
  }) {
    if (!isPersonalizedEnabled) {
      return 'Sleep, hydration, and activity tracked against symptoms.';
    }

    if (!hasCorrelations && avgSleep == null && avgStress == null) {
      return 'Log daily habits to see how sleep and stress influence your cycle comfort.';
    }

    if (avgSleep != null && avgSleep < 6.5) {
      return 'Shorter sleep can heighten cramp sensitivity. Extra rest can ease discomfort.';
    }

    if (avgStress != null && avgStress >= 6) {
      return 'Higher stress can amplify PMS and cramps. Calming routines before bed can help.';
    }

    if (avgSleep != null && avgSleep >= 7.5) {
      return 'Good sleep averages (${avgSleep.toStringAsFixed(1)} hrs) help keep your cycle symptoms manageable.';
    }

    return 'Consistent hydration and sleep are keeping your cycle patterns well balanced.';
  }

  // ==========================================================================
  // 5. COMPARE CYCLES PAGE: "Cycle-to-Cycle comparison"
  // ==========================================================================
  String getCompareCyclesInsight({
    required String cycle1Name,
    required String cycle2Name,
    required int? cycle1Length,
    required int? cycle2Length,
    required double? cycle1Pain,
    required double? cycle2Pain,
    required double? cycle1Sleep,
    required double? cycle2Sleep,
    required double? cycle1Stress,
    required double? cycle2Stress,
    bool isPersonalizedEnabled = true,
  }) {
    if (cycle1Length == null && cycle2Length == null && cycle1Pain == null && cycle2Pain == null) {
      return 'Track and complete your cycles to compare your symptoms, mood, and cycle lengths over time.';
    }

    final otherName = cycle2Name.toLowerCase().contains('cycle')
        ? cycle2Name.toLowerCase()
        : '${cycle2Name.toLowerCase()} cycle';

    final hasPainDiff = cycle1Pain != null && cycle2Pain != null;
    final painDiff = hasPainDiff ? cycle1Pain - cycle2Pain : 0.0;
    final isHigherPain = hasPainDiff && painDiff >= 0.5;
    final isMilderPain = hasPainDiff && painDiff <= -0.5;

    final hasSleepDiff = cycle1Sleep != null && cycle2Sleep != null;
    final sleepDiff = hasSleepDiff ? cycle1Sleep - cycle2Sleep : 0.0;
    final isShorterSleep = hasSleepDiff && sleepDiff <= -0.3;
    final isLongerSleep = hasSleepDiff && sleepDiff >= 0.3;

    final hasStressDiff = cycle1Stress != null && cycle2Stress != null;
    final stressDiff = hasStressDiff ? cycle1Stress - cycle2Stress : 0.0;
    final isHigherStress = hasStressDiff && stressDiff >= 0.5;
    final isLowerStress = hasStressDiff && stressDiff <= -0.5;

    final hasLengthDiff = cycle1Length != null && cycle2Length != null;
    final lenDiff = hasLengthDiff ? cycle1Length - cycle2Length : 0;

    // Both higher pain and shorter sleep / stress
    if (isHigherPain && (isShorterSleep || isHigherStress)) {
      return 'In this cycle, you experienced higher pain and shorter sleep compared to your $otherName. Prioritizing rest and hydration can help soothe your upcoming cycle.';
    }

    // Both milder pain and better sleep / stress
    if (isMilderPain && (isLongerSleep || isLowerStress)) {
      return 'Your symptoms were milder with longer sleep compared to your $otherName. Keeping up with regular rest and hydration supports this positive trend.';
    }

    // Higher pain
    if (isHigherPain) {
      return 'You experienced higher pain during this cycle compared to your $otherName. Gentle warmth, magnesium, and resting can help ease symptom intensity.';
    }

    // Milder pain
    if (isMilderPain) {
      return 'You experienced milder pain compared to your $otherName. Your body responded well this month with noticeably lighter physical discomfort.';
    }

    // Shorter sleep
    if (isShorterSleep) {
      return 'You had shorter sleep during this cycle compared to your $otherName. Giving yourself an earlier bedtime can help restore your daily stamina and focus.';
    }

    // Longer sleep
    if (isLongerSleep) {
      return 'You logged longer sleep during this cycle compared to your $otherName. Restful sleep provides strong support for steady moods and balanced energy.';
    }

    // Higher stress
    if (isHigherStress) {
      return 'Your stress ran higher during this cycle compared to your $otherName. Taking moments for gentle breathwork can help restore physical comfort.';
    }

    // Noticeable cycle length shift
    if (lenDiff.abs() >= 2) {
      final changeWord = lenDiff > 0 ? 'longer' : 'shorter';
      return 'This cycle was ${lenDiff.abs()} days $changeWord than your $otherName, while symptoms stayed steady. Minor monthly shifts are completely normal.';
    }

    // Consistent baseline
    return 'Both cycles showed very consistent patterns with similar pain, sleep, and duration. Your monthly rhythm has remained steady and balanced.';
  }
}
