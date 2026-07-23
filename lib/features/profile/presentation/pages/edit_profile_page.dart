import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/profile/presentation/state/profile_state.dart';
import 'package:sikhsha_sathi/features/profile/presentation/view_model/profile_view_model.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _showChangePassword = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  void initState() {
    super.initState();
    final session = ref.read(userSessionServiceProvider);
    _fullNameController =
        TextEditingController(text: session.getFullName() ?? '');
    _phoneController =
        TextEditingController(text: session.getPhoneNumber() ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();

    if (fullName.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full name is required')),
      );
      return;
    }

    if (_showChangePassword && newPassword.isNotEmpty && currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your current password to set a new one'),
        ),
      );
      return;
    }

    final success = await ref.read(profileViewModelProvider.notifier).updateProfile(
          fullName: fullName,
          phone: phone.isEmpty ? null : phone,
          currentPassword:
              _showChangePassword && newPassword.isNotEmpty ? currentPassword : null,
          newPassword:
              _showChangePassword && newPassword.isNotEmpty ? newPassword : null,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } else {
      final errorMessage = ref.read(profileViewModelProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Could not update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    final isSaving = profileState.status == ProfileStatus.loading;
    final session = ref.read(userSessionServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: _kPrimaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Full Name',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Email',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false,
              controller: TextEditingController(text: session.getEmail() ?? ''),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Email cannot be changed',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Phone Number',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // CHANGE PASSWORD (optional, collapsible)
            InkWell(
              onTap: () {
                setState(() {
                  _showChangePassword = !_showChangePassword;
                });
              },
              child: Row(
                children: [
                  Icon(
                    _showChangePassword ? Icons.expand_less : Icons.expand_more,
                    color: _kPrimaryBlue,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _kPrimaryBlue,
                    ),
                  ),
                ],
              ),
            ),

            if (_showChangePassword) ...[
              const SizedBox(height: 16),
              const Text(
                'Current Password',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'New Password',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  helperText: 'At least 6 characters',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}