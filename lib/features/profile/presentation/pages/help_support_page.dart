import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Help & Support',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              _buildSectionGroup(
                context,
                title: 'Quick Help',
                items: [
                  _buildTileItem(Icons.help_outline, 'Frequently Asked Questions', () { context.push('/faq'); }),
                  _buildTileItem(Icons.build_circle_outlined, 'Troubleshooting', () { context.push('/troubleshooting'); }),
                ],
              ),

              const SizedBox(height: 32),

              _buildSectionGroup(
                context,
                title: 'Contact Us',
                items: [
                  _buildTileItem(Icons.chat_bubble_outline, 'Contact Support', () { context.push('/contact_support'); }),
                  _buildTileItem(Icons.bug_report_outlined, 'Report a Problem', () { context.push('/report_problem'); }),
                  _buildTileItem(Icons.lightbulb_outline, 'Suggest a Feature', () { context.push('/suggest_feature'); }),
                  _buildTileItem(Icons.star_outline, 'Give Feedback', () { context.push('/give_feedback'); }),
                ],
              ),

              const SizedBox(height: 32),

              _buildSectionGroup(
                context,
                title: 'Health & Safety',
                items: [
                  _buildTileItem(Icons.info_outline, 'Medical Disclaimer', () { context.push('/medical_disclaimer'); }),
                  _buildTileItem(Icons.medical_services_outlined, 'When to seek medical help', () { context.push('/when_to_seek_help'); }),
                  _buildTileItem(Icons.warning_amber_rounded, 'Emergency information', () { context.push('/when_to_seek_help'); }),
                ],
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionGroup(BuildContext context, {required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: List.generate(items.length, (index) {
              return Column(
                children: [
                  items[index],
                  if (index < items.length - 1)
                    const Divider(color: AppColors.border, height: 1),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTileItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.lightPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: AppColors.primaryPurple,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.border,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
