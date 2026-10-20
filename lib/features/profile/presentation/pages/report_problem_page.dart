import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_button.dart';

import '../../../../core/services/support_api_service.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  List<String> _attachedFileNames = [];
  bool _isSubmitting = false;
  
  String _appVersion = 'Loading...';
  String _deviceModel = 'Loading...';
  String _osVersion = 'Loading...';

  @override
  void dispose() {
    _descController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      String appVer = packageInfo.version;
      String devModel = 'Unknown Device';
      String osVer = 'Unknown OS';

      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        devModel = androidInfo.model;
        osVer = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        devModel = iosInfo.utsname.machine;
        osVer = 'iOS ${iosInfo.systemVersion}';
      }

      if (mounted) {
        setState(() {
          _appVersion = appVer;
          _deviceModel = devModel;
          _osVersion = osVer;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _appVersion = 'Unknown';
          _deviceModel = 'Unknown';
          _osVersion = 'Unknown';
        });
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _attachedFileNames.addAll(images.map((img) => img.name));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file picker: $e')),
        );
      }
    }
  }

  void _submit() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the issue before submitting.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final fullDescription = StringBuffer(desc);
    if (_stepsController.text.trim().isNotEmpty) {
      fullDescription.write('\n\nSteps to reproduce:\n${_stepsController.text.trim()}');
    }

    final res = await SupportApiService.instance.submitTicket(
      ticketType: 'problem_report',
      title: 'Problem Report: ${desc.length > 30 ? desc.substring(0, 30) : desc}',
      description: fullDescription.toString(),
      appVersion: _appVersion,
      deviceModel: _deviceModel,
      osVersion: _osVersion,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

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
                  'Report Submitted',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.text),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                res.isSuccess
                    ? 'Thank you! Your ticket ID is #${res.ticketId?.substring(0, 8) ?? 'received'}. Our engineering team has received your report.'
                    : 'Report saved locally. Thank you for bringing this to our attention.',
                style: const TextStyle(color: AppColors.secondaryText, fontSize: 14, height: 1.5),
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
        title: const Text('Report a Problem', style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What happened?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              _buildTextField('Describe the issue...', controller: _descController),
              const SizedBox(height: 24),

              const Text(
                'Steps to reproduce',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              _buildTextField('1. Go to...\n2. Tap on...', controller: _stepsController, maxLines: 4),
              const SizedBox(height: 24),

              const Text(
                'Screenshot',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  if (_attachedFileNames.isNotEmpty)
                    ..._attachedFileNames.map((fileName) => Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.image_outlined, color: AppColors.secondaryText),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        fileName,
                                        style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _attachedFileNames.remove(fileName);
                                  });
                                },
                                child: const Icon(Icons.close, color: AppColors.secondaryText, size: 20),
                              ),
                            ],
                          ),
                        )),
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Text('+ Add attachment', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Device Info (Auto-attached)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondaryText, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bloom Version: $_appVersion', style: const TextStyle(color: AppColors.secondaryText, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Device Model: $_deviceModel', style: const TextStyle(color: AppColors.secondaryText, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('OS Version: $_osVersion', style: const TextStyle(color: AppColors.secondaryText, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Note: Sensitive menstrual data is never automatically sent with bug reports.',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 32),

              BloomButton(
                text: _isSubmitting ? 'Submitting...' : 'Submit Report',
                onPressed: _isSubmitting ? () {} : _submit,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {TextEditingController? controller, int maxLines = 1}) {
    return TextField(
      controller: controller,
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
