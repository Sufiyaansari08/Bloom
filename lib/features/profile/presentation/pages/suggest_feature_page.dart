import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_button.dart';

class SuggestFeaturePage extends StatefulWidget {
  const SuggestFeaturePage({super.key});

  @override
  State<SuggestFeaturePage> createState() => _SuggestFeaturePageState();
}

class _SuggestFeaturePageState extends State<SuggestFeaturePage> {


  void _submit() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Suggestion Sent',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.text),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Thank you for helping us improve Bloom!',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.text), onPressed: () => context.pop()),
        title: const Text('Suggest a Feature', style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Have an idea for Bloom?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
              ),
              const SizedBox(height: 8),
              const Text(
                'We love hearing what you want to see next!',
                style: TextStyle(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 24),

              const Text(
                'Feature Name',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              _buildTextField('E.g., Dark Mode'),
              const SizedBox(height: 24),

              const Text(
                'Description',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              _buildTextField('How should it work?', maxLines: 4),
              const SizedBox(height: 24),

              const Text(
                'Why would it be useful?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              _buildTextField('Explain how it helps you...', maxLines: 3),
              const SizedBox(height: 32),

              BloomButton(
                text: 'Submit Suggestion',
                onPressed: _submit,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
      ),
    );
  }
}
