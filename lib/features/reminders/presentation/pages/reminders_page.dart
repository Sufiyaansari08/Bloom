import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Reminders',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: const [
          ReminderBox(
            title: 'Log your symptoms',
            description: 'Log your daily symptoms to get better insights.',
            date: 'Today',
            time: '08:00 AM',
            icon: Icons.edit_note,
            color: AppColors.primaryPink,
          ),
          SizedBox(height: 16),
          ReminderBox(
            title: 'Hydration check',
            description: 'Time for a glass of water!',
            date: 'Today',
            time: '12:30 PM',
            icon: Icons.local_drink_outlined,
            color: Colors.blue,
          ),
          SizedBox(height: 16),
          ReminderBox(
            title: 'Period expected soon',
            description: 'Your period is predicted to start in 2 days.',
            date: 'Yesterday',
            time: '09:00 AM',
            icon: Icons.water_drop_outlined,
            color: AppColors.primaryPink,
          ),
        ],
      ),
    );
  }
}

class ReminderBox extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final IconData icon;
  final Color color;

  const ReminderBox({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  State<ReminderBox> createState() => _ReminderBoxState();
}

class _ReminderBoxState extends State<ReminderBox> {
  bool _showTime = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showTime = !_showTime;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: widget.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: _showTime
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: AppColors.secondaryText),
                                const SizedBox(width: 4),
                                Text(
                                  widget.time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
