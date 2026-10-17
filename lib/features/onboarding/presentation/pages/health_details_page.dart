import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_app_bar.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_lifestyle_card.dart';

class HealthDetailsPage extends ConsumerStatefulWidget {
  const HealthDetailsPage({super.key});

  @override
  ConsumerState<HealthDetailsPage> createState() => _HealthDetailsPageState();
}

class _HealthDetailsPageState extends ConsumerState<HealthDetailsPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  DateTime? _selectedDob;
  String _selectedBloodGroup = "Don't know";

  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
    "Don't know",
  ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingProvider);
    _selectedDob = state.dateOfBirth;
    if (state.heightCm != null && state.heightCm! > 0) {
      _heightController.text = state.heightCm!.toInt().toString();
    }
    if (state.weightKg != null && state.weightKg! > 0) {
      _weightController.text = state.weightKg!.toInt().toString();
    }
    if (state.bloodGroup != null && bloodGroups.contains(state.bloodGroup)) {
      _selectedBloodGroup = state.bloodGroup!;
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = _selectedDob ?? DateTime(now.year - 22, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.text,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  void _onContinue() {
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());

    ref.read(onboardingProvider.notifier).setHealthDetails(
      dateOfBirth: _selectedDob,
      heightCm: height,
      weightKg: weight,
      bloodGroup: _selectedBloodGroup,
    );

    context.push('/onboarding/last_period');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BloomAppBar(
        progress: 0.25,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'These details help personalize your health insights and clinical doctor reports.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondaryText,
                    ),
              ),
              const SizedBox(height: 32),

              // Date of Birth Field
              const Text(
                'Date of Birth',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDateOfBirth,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: AppColors.primaryPink,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDob != null
                                ? DateFormat('MMMM d, yyyy').format(_selectedDob!)
                                : 'Select your date of birth',
                            style: TextStyle(
                              fontSize: 15,
                              color: _selectedDob != null ? AppColors.text : AppColors.secondaryText,
                              fontWeight: _selectedDob != null ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Height and Weight Row
              Row(
                children: [
                  // Height
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Height',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _heightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: 'e.g. 165',
                            hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
                            suffixText: 'cm',
                            suffixStyle: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Weight
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weight',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: 'e.g. 60',
                            hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
                            suffixText: 'kg',
                            suffixStyle: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Blood Group Dropdown Card (Exact Daily Checkin Style)
              BloomLifestyleCard(
                title: 'Blood Group',
                icon: Icons.bloodtype,
                iconColor: AppColors.primaryPink,
                trailing: PopupMenuButton<String>(
                  initialValue: _selectedBloodGroup,
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  elevation: 4,
                  constraints: const BoxConstraints(maxHeight: 260),
                  onSelected: (val) {
                    setState(() {
                      _selectedBloodGroup = val;
                    });
                  },
                  itemBuilder: (context) => bloodGroups
                      .map((e) => PopupMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: e == "Don't know"
                                        ? AppColors.secondaryText
                                        : AppColors.text,
                                  ),
                            ),
                          ))
                      .toList(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedBloodGroup,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _selectedBloodGroup == "Don't know"
                                  ? AppColors.secondaryText
                                  : AppColors.text,
                            ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              BloomButton(
                text: 'Continue',
                onPressed: _onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
