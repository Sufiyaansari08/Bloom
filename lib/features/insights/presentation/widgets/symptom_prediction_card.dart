import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SymptomPredictionCard extends StatelessWidget {
  final String symptom;
  final String prediction;
  final IconData icon;

  const SymptomPredictionCard({
    super.key,
    required this.symptom,
    required this.prediction,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.lightPink,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryPurple),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                symptom,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                prediction,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
