import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('History', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('History page coming soon...', style: TextStyle(color: AppColors.secondaryText)),
      ),
    );
  }
}
