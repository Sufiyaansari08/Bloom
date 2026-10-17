import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../profile/presentation/providers/privacy_security_provider.dart';
import 'doctor_report_service.dart';

enum AiSummaryStatus {
  initial,
  loading,
  success,
  error,
}

class AiSummaryState {
  final AiSummaryStatus status;
  final String summary;
  final bool isAiGenerated;
  final String? errorMessage;

  const AiSummaryState({
    required this.status,
    required this.summary,
    this.isAiGenerated = false,
    this.errorMessage,
  });

  AiSummaryState copyWith({
    AiSummaryStatus? status,
    String? summary,
    bool? isAiGenerated,
    String? errorMessage,
  }) {
    return AiSummaryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      isAiGenerated: isAiGenerated ?? this.isAiGenerated,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DoctorReportAiService {
  DoctorReportAiService._();

  /// Set this URL when your backend developer provides the endpoint.
  /// Example: 'https://your-project.supabase.co/functions/v1/generate-doctor-summary'
  /// If null or empty, the service runs in smart Mock/Dev mode.
  static String? backendUrl;

  /// Optional bearer / API token for backend authorization.
  static String? authToken;

  /// Delay used for simulating AI generation in mock mode (can be set to Duration.zero in tests).
  static Duration mockDelay = const Duration(milliseconds: 1200);

  /// Converts [DoctorReportData] into a structured payload for the backend.
  static Map<String, dynamic> buildPayload(DoctorReportData data) {
    return {
      'patient': {
        'age': data.userAge,
        'height': data.userHeight,
        'weight': data.userWeight,
        'bloodGroup': data.userBloodGroup,
      },
      'cycleMetrics': {
        'cycleCount': data.cycleCount,
        'avgCycleLength': data.avgCycleLength,
        'cycleVariationDays': data.cycleVariationDays,
        'shortestCycle': data.shortestCycle,
        'longestCycle': data.longestCycle,
        'cycleRange': data.cycleRange,
        'variationText': data.variationText,
      },
      'periodMetrics': {
        'avgPeriodLength': data.avgPeriodLength,
        'shortestPeriod': data.shortestPeriod,
        'longestPeriod': data.longestPeriod,
      },
      'symptomsAndPain': {
        'avgPainLevel': data.avgPainLevel,
        'painLabel': data.painLabel,
        'painLevelText': data.painLevelText,
        'topSymptoms': data.symptomPatterns.map((s) => {
          'name': s.name,
          'subtitle': s.subtitle,
          'phase': s.phase,
        }).toList(),
      },
      'moodTrends': data.moodTrends.map((m) => {
        'mood': m.mood,
        'subtitle': m.subtitle,
        'phase': m.phase,
      }).toList(),
      'lifestyle': {
        'sleep': data.sleepFormatted,
        'water': data.waterFormatted,
        'activity': data.activityFormatted,
        'stress': data.stressFormatted,
      },
    };
  }

  /// Calls the backend endpoint or generates a simulated clinical summary.
  static Future<String> generateClinicalSummary(DoctorReportData data) async {
    final url = backendUrl?.trim();

    if (url != null && url.isNotEmpty) {
      try {
        final payload = buildPayload(data);
        final headers = <String, String>{
          'Content-Type': 'application/json',
          if (authToken != null && authToken!.isNotEmpty)
            'Authorization': 'Bearer $authToken',
        };

        final response = await http
            .post(
              Uri.parse(url),
              headers: headers,
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 15));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            if (decoded.containsKey('summary')) {
              return decoded['summary'].toString().trim();
            } else if (decoded.containsKey('data') &&
                decoded['data'] is Map &&
                decoded['data']['summary'] != null) {
              return decoded['data']['summary'].toString().trim();
            }
          }
          return response.body.trim();
        } else {
          throw Exception('Backend returned status ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        debugPrint('Error contacting AI backend: $e. Falling back to local generation.');
        rethrow;
      }
    }

    // Smart Local Mock Mode: Simulates network latency and generates rich clinical insights
    if (mockDelay > Duration.zero) {
      await Future.delayed(mockDelay);
    }
    return _generateSmartMockSummary(data);
  }

  /// Generates a contextual clinical summary based on real data points.
  static String _generateSmartMockSummary(DoctorReportData data) {
    final buffer = StringBuffer();

    // 1. Cycle & Ovulatory Patterns
    if (data.cycleCount > 0) {
      if (data.cycleVariationDays <= 3) {
        buffer.write(
          'Clinical records across ${data.cycleCount} recorded cycles indicate regular ovulatory rhythm with an average cycle length of ${data.avgCycleLength} days (variation ±${data.cycleVariationDays} days). Menstrual duration maintains stability at an average of ${data.avgPeriodLength} days. ',
        );
      } else {
        buffer.write(
          'Analysis of ${data.cycleCount} tracked cycles demonstrates notable variability in cycle duration (range ${data.cycleRange} days, variance ±${data.cycleVariationDays} days) with an average length of ${data.avgCycleLength} days. Menstrual bleeding averages ${data.avgPeriodLength} days. ',
        );
      }
    } else {
      buffer.write(
        'Based on baseline patient onboarding records, cycle length averages ${data.avgCycleLength} days with a typical duration of ${data.avgPeriodLength} days. ',
      );
    }

    // 2. Pain & Symptom Manifestations
    if (data.avgPainLevel != null && data.avgPainLevel! > 0) {
      final painSeverity = data.avgPainLevel! >= 6.0
          ? 'acute primary dysmenorrhea'
          : data.avgPainLevel! >= 3.5
              ? 'moderate menstrual cramping'
              : 'mild perimenstrual discomfort';

      buffer.write(
        'Symptom tracking highlights recurrent $painSeverity (average rating ${data.avgPainLevel!.toStringAsFixed(1)}/10, ${data.painLabel.toLowerCase()}), predominantly manifesting during the onset of menstruation. ',
      );
    } else {
      buffer.write(
        'Minimal to no significant pelvic pain or severe cramping discomfort was logged during this evaluation window. ',
      );
    }

    // 3. Most Common Symptoms
    if (data.symptomPatterns.isNotEmpty) {
      final topSymptoms = data.symptomPatterns.take(3).map((s) => s.name.toLowerCase()).toList();
      buffer.write(
        'Frequent concurrent physiological symptoms include ${topSymptoms.join(', ')}, showing cyclical correlation with phase transitions. ',
      );
    }

    // 4. Lifestyle & Neuroendocrine Factors
    final hasSleep = data.sleepFormatted != 'No data';
    final hasStress = data.stressFormatted != 'No data';

    if (hasSleep || hasStress) {
      final sleepNotes = hasSleep ? '${data.sleepFormatted} of sleep' : 'steady rest';
      final stressNotes = hasStress ? '${data.stressFormatted} stress levels' : 'stable stress';
      buffer.write(
        'Lifestyle logs indicate $sleepNotes and $stressNotes. Sustaining circadian rhythm integrity and targeted stress reduction may further alleviate menstrual discomfort.',
      );
    }

    return buffer.toString().trim();
  }
}

/// Riverpod Notifier for managing AI observation summary state.
class DoctorReportAiNotifier extends StateNotifier<AiSummaryState> {
  final DoctorReportData reportData;
  final bool isAiEnabled;

  DoctorReportAiNotifier(this.reportData, {this.isAiEnabled = true})
      : super(AiSummaryState(
          status: isAiEnabled ? AiSummaryStatus.initial : AiSummaryStatus.success,
          summary: reportData.observationsSummary,
          isAiGenerated: false,
        )) {
    if (isAiEnabled) {
      generateAiSummary();
    }
  }

  Future<void> generateAiSummary({bool force = false}) async {
    if (!isAiEnabled) {
      state = state.copyWith(
        status: AiSummaryStatus.success,
        summary: reportData.observationsSummary,
        isAiGenerated: false,
        errorMessage: null,
      );
      return;
    }

    if (state.status == AiSummaryStatus.loading && !force) return;

    state = state.copyWith(
      status: AiSummaryStatus.loading,
      errorMessage: null,
    );

    try {
      final aiSummary = await DoctorReportAiService.generateClinicalSummary(reportData);
      state = state.copyWith(
        status: AiSummaryStatus.success,
        summary: aiSummary,
        isAiGenerated: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: AiSummaryStatus.error,
        summary: reportData.observationsSummary, // Keep safe fallback
        errorMessage: 'Unable to connect to AI server. Showing baseline observations.',
        isAiGenerated: false,
      );
    }
  }

  void updateSummary(String newSummary) {
    if (!isAiEnabled) return;
    state = state.copyWith(
      summary: newSummary,
      isAiGenerated: true,
    );
  }
}

/// Family provider keyed by report metadata string to prevent unnecessary refreshes
final doctorReportAiProvider = StateNotifierProvider.family<
    DoctorReportAiNotifier,
    AiSummaryState,
    DoctorReportData>((ref, reportData) {
  final isAiEnabled = ref.watch(
    privacySecurityProvider.select((s) => s.isAiDataUsageEnabled),
  );
  return DoctorReportAiNotifier(reportData, isAiEnabled: isAiEnabled);
});
