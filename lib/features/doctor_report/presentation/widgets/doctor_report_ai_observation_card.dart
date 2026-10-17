import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../services/doctor_report_service.dart';
import '../../services/doctor_report_ai_service.dart';
import '../../../profile/presentation/providers/privacy_security_provider.dart';

class DoctorReportAiObservationCard extends ConsumerStatefulWidget {
  final DoctorReportData reportData;

  const DoctorReportAiObservationCard({
    super.key,
    required this.reportData,
  });

  @override
  ConsumerState<DoctorReportAiObservationCard> createState() =>
      _DoctorReportAiObservationCardState();
}

class _DoctorReportAiObservationCardState
    extends ConsumerState<DoctorReportAiObservationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAiEnabled = ref.watch(
      privacySecurityProvider.select((s) => s.isAiDataUsageEnabled),
    );
    final aiState = ref.watch(doctorReportAiProvider(widget.reportData));
    final activeSummary = (isAiEnabled &&
            aiState.summary.isNotEmpty &&
            aiState.isAiGenerated)
        ? aiState.summary
        : widget.reportData.observationsSummary;
    final isLoading = isAiEnabled && aiState.status == AiSummaryStatus.loading;

    if (isLoading) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController.stop();
      }
    }

    return Container(
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
        border: Border.all(
          color: AppColors.primaryPink.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI Badge & Regenerate CTA
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
              const SizedBox(width: 10),
              const Text(
                'Your body summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              const Spacer(),
              if (isAiEnabled) ...[
                if (isLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryPurple,
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.primaryPurple,
                      size: 20,
                    ),
                    tooltip: 'Regenerate AI summary',
                    onPressed: () {
                      ref
                          .read(doctorReportAiProvider(widget.reportData).notifier)
                          .generateAiSummary(force: true);
                    },
                  ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          // Error / Warning Banner if fallback
          if (aiState.status == AiSummaryStatus.error) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 16,
                    color: Colors.amber.shade800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI server unavailable. Showing baseline observations.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(doctorReportAiProvider(widget.reportData).notifier)
                          .generateAiSummary(force: true);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Content: Loading Shimmer or Text
          if (isLoading) ...[
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _pulseAnimation.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FractionallySizedBox(
                        widthFactor: 0.75,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.auto_awesome,
                              size: 13,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Bloom AI is analyzing your cycle trends & clinical markers...',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: AppColors.primaryPurple,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ] else ...[
            Text(
              activeSummary,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.text,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  (!isAiEnabled)
                      ? Icons.shield_outlined
                      : (aiState.isAiGenerated
                          ? Icons.check_circle_outline_rounded
                          : Icons.info_outline_rounded),
                  size: 14,
                  color: (!isAiEnabled)
                      ? AppColors.secondaryText
                      : (aiState.isAiGenerated
                          ? Colors.teal.shade600
                          : AppColors.secondaryText),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (!isAiEnabled)
                        ? 'Base summary displayed (AI data usage disabled in Privacy & Security)'
                        : (aiState.isAiGenerated
                            ? 'AI synthesis ready for doctor review'
                            : 'Baseline diagnostic observations'),
                    style: TextStyle(
                      fontSize: 11,
                      color: (isAiEnabled && aiState.isAiGenerated)
                          ? Colors.teal.shade700
                          : AppColors.secondaryText,
                      fontWeight: (isAiEnabled && aiState.isAiGenerated)
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
