import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../shared/widgets/bloom_button.dart';
import '../../../../shared/widgets/bloom_lifestyle_card.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  DateTime? _selectedDob;
  String _selectedBloodGroup = "Don't know";
  String _currentAvatar = 'assets/images/Setting_avatar.png';
  bool _initialized = false;

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
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileStreamProvider);

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
          'Edit Profile',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Profile not found'));
          }

          if (!_initialized) {
            _nameController.text = user.name;
            _emailController.text = user.email ?? '';
            _phoneController.text = user.phone ?? '';
            _selectedDob = user.dateOfBirth;
            if (user.heightCm != null && user.heightCm! > 0) {
              _heightController.text = user.heightCm!.toInt().toString();
            }
            if (user.weightKg != null && user.weightKg! > 0) {
              _weightController.text = user.weightKg!.toInt().toString();
            }
            if (user.bloodGroup != null && bloodGroups.contains(user.bloodGroup)) {
              _selectedBloodGroup = user.bloodGroup!;
            }
            _currentAvatar =
                user.avatarPath ?? 'assets/images/Setting_avatar.png';
            _initialized = true;
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Section
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryPink,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: AssetImage(_currentAvatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Profile Photo',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Enter your name',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth
                    _buildDobPicker(context),
                    const SizedBox(height: 16),

                    // Height and Weight Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _heightController,
                            label: 'Height',
                            hint: 'e.g. 165',
                            suffixText: 'cm',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _weightController,
                            label: 'Weight',
                            hint: 'e.g. 60',
                            suffixText: 'kg',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Blood Group Dropdown Card (Daily Checkin Style)
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
                    const SizedBox(height: 8),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      hint: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Change Password
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Change password coming soon!'),
                            ),
                          );
                        },
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Changes
                    BloomButton(
                      text: 'Save Changes',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final userRepo = ref.read(userRepositoryProvider);
                          final height = double.tryParse(_heightController.text.trim());
                          final weight = double.tryParse(_weightController.text.trim());

                          final updatedUser = user
                              .toCompanion(true)
                              .copyWith(
                                name: drift.Value(_nameController.text.trim()),
                                email: drift.Value(
                                  _emailController.text.trim().isEmpty
                                      ? null
                                      : _emailController.text.trim(),
                                ),
                                phone: drift.Value(
                                  _phoneController.text.trim().isEmpty
                                      ? null
                                      : _phoneController.text.trim(),
                                ),
                                dateOfBirth: drift.Value(_selectedDob),
                                heightCm: drift.Value(height),
                                weightKg: drift.Value(weight),
                                bloodGroup: drift.Value(_selectedBloodGroup),
                                avatarPath: drift.Value(_currentAvatar),
                              );
                          await userRepo.saveUserProfile(updatedUser);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated!')),
                            );
                            context.pop();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? suffixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            suffixText: suffixText,
            suffixStyle: const TextStyle(
              color: AppColors.primaryPurple,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            suffixIcon: suffixText == null
                ? const Icon(
                    Icons.edit,
                    color: AppColors.secondaryText,
                    size: 20,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primaryPink,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDobPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Birth',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate:
                  _selectedDob ??
                  DateTime.now().subtract(const Duration(days: 365 * 20)),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primaryPink,
                      onPrimary: Colors.white,
                      surface: AppColors.background,
                      onSurface: AppColors.text,
                    ),
                    dialogTheme: const DialogThemeData(
                      backgroundColor: AppColors.background,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryPink,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() {
                _selectedDob = date;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDob != null
                      ? DateFormat('MMMM d, yyyy').format(_selectedDob!)
                      : 'Select your date of birth',
                  style: TextStyle(
                    color: _selectedDob != null
                        ? AppColors.text
                        : AppColors.secondaryText,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.edit,
                  color: AppColors.secondaryText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
