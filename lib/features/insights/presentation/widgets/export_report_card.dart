import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ExportReportCard extends StatelessWidget {
  const ExportReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need to share data\nwith your doctor?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Export logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryPurple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Export PDF'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.document_scanner_outlined,
            size: 48,
            color: AppColors.primaryPink,
          ),
        ],
      ),
    );
  }
}
