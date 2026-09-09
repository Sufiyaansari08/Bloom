import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../shared/widgets/bloom_button.dart';

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
  
  DateTime? _selectedDob;
  String _currentAvatar = 'assets/images/Setting_avatar.png';
  bool _initialized = false;

  final List<String> _availableAvatars = const [
    'assets/images/Setting_avatar.png',
    'assets/images/body_avatar.png',
    'assets/images/doctor_avatar.jpg',
    'assets/images/low_mood_avatar.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
          if (user == null) return const Center(child: Text('Profile not found'));
          
          if (!_initialized) {
            _nameController.text = user.name;
            _emailController.text = user.email ?? '';
            _phoneController.text = user.phone ?? '';
            _selectedDob = user.dateOfBirth;
            _currentAvatar = user.avatarPath ?? 'assets/images/Setting_avatar.png';
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
                          Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryPink, width: 2),
                                  image: DecorationImage(
                                    image: AssetImage(_currentAvatar),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _showAvatarPicker(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryPink,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Profile Photo',
                            style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Name
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Enter your name',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Name cannot be empty';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Date of Birth
                    _buildDobPicker(context),
                    const SizedBox(height: 20),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Phone
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      hint: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),

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
                            const SnackBar(content: Text('Change password coming soon!')),
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
                    const SizedBox(height: 32),

                    // Save Changes
                    BloomButton(
                      text: 'Save Changes',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final userRepo = ref.read(userRepositoryProvider);
                          final updatedUser = user.toCompanion(true).copyWith(
                                name: drift.Value(_nameController.text.trim()),
                                email: drift.Value(_emailController.text.trim().isEmpty ? null : _emailController.text.trim()),
                                phone: drift.Value(_phoneController.text.trim().isEmpty ? null : _phoneController.text.trim()),
                                dateOfBirth: drift.Value(_selectedDob),
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
            suffixIcon: const Icon(Icons.edit, color: AppColors.secondaryText, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
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
              initialDate: _selectedDob ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
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
                  _selectedDob != null ? DateFormat('MMMM d, yyyy').format(_selectedDob!) : 'Select your date of birth',
                  style: TextStyle(
                    color: _selectedDob != null ? AppColors.text : AppColors.secondaryText,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.edit, color: AppColors.secondaryText, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAvatarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Profile Avatar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _availableAvatars.length,
                itemBuilder: (context, index) {
                  final avatarPath = _availableAvatars[index];
                  final isSelected = avatarPath == _currentAvatar;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentAvatar = avatarPath;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: AppColors.primaryPink, width: 3) : null,
                        image: DecorationImage(
                          image: AssetImage(avatarPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
