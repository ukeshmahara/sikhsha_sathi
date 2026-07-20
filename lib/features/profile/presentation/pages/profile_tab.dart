import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sikhsha_sathi/core/api/api_endpoints.dart';
import 'package:sikhsha_sathi/core/services/biometric/biometric_service.dart';
import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/app/locale/app_strings.dart';
import 'package:sikhsha_sathi/app/locale/locale_state.dart';
import 'package:sikhsha_sathi/app/locale/locale_view_model.dart';
import 'package:sikhsha_sathi/app/theme/app_colors.dart';
import 'package:sikhsha_sathi/app/theme/theme_state.dart';
import 'package:sikhsha_sathi/app/theme/theme_view_model.dart';
import 'package:sikhsha_sathi/features/auth/domain/usecases/login_usecase.dart';
import 'package:sikhsha_sathi/features/auth/presentation/pages/login_view.dart';
import 'package:sikhsha_sathi/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:sikhsha_sathi/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:sikhsha_sathi/features/profile/presentation/pages/help_support_page.dart';
import 'package:sikhsha_sathi/features/profile/presentation/pages/privacy_policy_page.dart';
import 'package:sikhsha_sathi/features/profile/presentation/pages/terms_of_service_page.dart';
import 'package:sikhsha_sathi/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:sikhsha_sathi/features/profile/presentation/state/profile_state.dart';
import 'package:sikhsha_sathi/features/school/presentation/view_model/school_view_model.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() =>
      _ProfileTabState();
}

class _ProfileTabState
    extends ConsumerState<ProfileTab> {
  File? _selectedImage;

  final ImagePicker _imagePicker =
      ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).refreshProfile();
    });
  }

  Future<Permission>
      _getGalleryPermission() async {
    if (Platform.isAndroid) {
      final androidInfo =
          await DeviceInfoPlugin()
              .androidInfo;

      return androidInfo.version.sdkInt >= 33
          ? Permission.photos
          : Permission.storage;
    }

    return Permission.photos;
  }

  Future<bool> _userPermission(
    Permission permission,
  ) async {
    final status =
        await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result =
          await permission.request();

      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            const Text("Permission Required"),
        content: const Text(
          "Please allow camera and gallery access.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child:
                const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _cameraPermission() async {
    final hasPermission =
        await _userPermission(
      Permission.camera,
    );

    if (!hasPermission) {
      return;
    }

    final XFile? photo =
        await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      final imageFile = File(photo.path);

      setState(() {
        _selectedImage = imageFile;
      });

      await ref
          .read(profileViewModelProvider.notifier)
          .uploadProfilePicture(imageFile);
    }
  }

  Future<void> _galleryPermission() async {
    final permission =
        await _getGalleryPermission();

    final hasPermission =
        await _userPermission(
      permission,
    );

    if (!hasPermission) {
      return;
    }

    final XFile? photo =
        await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (photo != null) {
      final imageFile = File(photo.path);

      setState(() {
        _selectedImage = imageFile;
      });

      await ref
          .read(profileViewModelProvider.notifier)
          .uploadProfilePicture(imageFile);
    }
  }

  Future<void>
      _showMediaSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
              ),
              title:
                  const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _cameraPermission();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
              ),
              title: const Text(
                "Choose from Gallery",
              ),
              onTap: () {
                Navigator.pop(context);
                _galleryPermission();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.close),
              title: const Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final session =
        ref.read(userSessionServiceProvider);

    final savedProfilePicture =
        session.getProfilePicture();

    final savedProfilePictureUrl = savedProfilePicture != null &&
            savedProfilePicture.isNotEmpty
        ? '${ApiEndpoints.baseUrl.replaceAll('/api/v1', '')}$savedProfilePicture'
        : null;

    final profileState =
        ref.watch(profileViewModelProvider);

    final lang = ref.watch(localeViewModelProvider).language;

    final fullName =
        session.getFullName() ??
            AppStrings.get('unknownUser', lang);

    final email =
        session.getEmail() ??
            AppStrings.get('noEmail', lang);

    final phone =
        session.getPhoneNumber() ??
            AppStrings.get('noPhone', lang);

    return Scaffold(
      backgroundColor:
          context.appBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
                  EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 30,
                bottom: 20,
              ),
              decoration:
                  const BoxDecoration(
                color: Color(0xFF185FA5),
              ),
              child: Center(
                child: Text(
                  AppStrings.get('profile', lang),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Stack(
              children: [
                GestureDetector(
                  onTap:
                      _showMediaSourceDialog,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        context.appSurface,
                    backgroundImage:
                        _selectedImage != null
                            ? FileImage(
                                _selectedImage!,
                              )
                            : savedProfilePictureUrl != null
                                ? NetworkImage(
                                    savedProfilePictureUrl,
                                  )
                                : null,
                    child:
                        _selectedImage == null &&
                                savedProfilePictureUrl == null
                            ? Icon(
                                Icons.person,
                                size: 80,
                                color:
                                    context.appTextSecondary,
                              )
                            : null,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap:
                        _showMediaSourceDialog,
                    child: Container(
                      padding:
                          const EdgeInsets
                              .all(8),
                      decoration:
                          const BoxDecoration(
                        color: Colors.blue,
                        shape:
                            BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color:
                            Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (profileState.status ==
                ProfileStatus.loading)
              const CircularProgressIndicator(),

            if (profileState.status ==
                ProfileStatus.error)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  profileState.errorMessage ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),

            Text(
              fullName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              email,
              style: TextStyle(
                color:
                    context.appTextSecondary,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 30),

            _profileTile(
              Icons.person_outline,
              AppStrings.get('fullName', lang),
              fullName,
            ),

            _profileTile(
              Icons.email_outlined,
              AppStrings.get('email', lang),
              email,
            ),

            _profileTile(
              Icons.phone_outlined,
              AppStrings.get('phoneNumber', lang),
              phone,
            ),

            const SizedBox(height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: _buildThemeToggle(ref, lang),
            ),

            const SizedBox(height: 10),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: _buildBiometricToggle(context, ref, lang),
            ),

            const SizedBox(height: 10),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: _buildLanguageToggle(context, ref, lang),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.appTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _supportRow(
                    context,
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportPage(),
                        ),
                      );
                    },
                  ),
                  _supportRow(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                  ),
                  _supportRow(
                    context,
                    icon: Icons.description_outlined,
                    label: 'Terms of Service',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsOfServicePage(),
                        ),
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                  icon:
                      const Icon(Icons.edit),
                  label: Text(
                    AppStrings.get('editProfile', lang),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,
                  ),
                  onPressed: () async {
                    await ref
                        .read(favouriteViewModelProvider.notifier)
                        .clearCache();

                    await session
                        .clearSession();

                    ref.invalidate(schoolViewModelProvider);
                    ref.invalidate(profileViewModelProvider);

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginView(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                  label: Text(
                    AppStrings.get('logout', lang),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 30,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(
                    color: context.appTextSecondary,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  value,
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: context.appSurface,
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(12))
          : BorderRadius.zero,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(bottom: BorderSide(color: context.appBorder)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: context.appTextSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appTextPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: context.appTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmPasswordBeforeEnabling(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final session = ref.read(userSessionServiceProvider);
    final email = session.getEmail();

    if (email == null || email.isEmpty) {
      return false;
    }

    final passwordController = TextEditingController();
    bool obscure = true;
    String? errorText;
    bool isVerifying = false;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Confirm your password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'For your security, please enter your password to enable fingerprint login.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: obscure,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: errorText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setDialogState(() => obscure = !obscure);
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isVerifying
                      ? null
                      : () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isVerifying
                      ? null
                      : () async {
                          final password = passwordController.text.trim();

                          if (password.isEmpty) {
                            setDialogState(() {
                              errorText = 'Please enter your password';
                            });
                            return;
                          }

                          setDialogState(() {
                            isVerifying = true;
                            errorText = null;
                          });

                          final loginUsecase = ref.read(loginUsecaseProvider);

                          final result = await loginUsecase(
                            LoginParams(email: email, password: password),
                          );

                          if (!dialogContext.mounted) return;

                          result.fold(
                            (failure) {
                              setDialogState(() {
                                isVerifying = false;
                                errorText = 'Incorrect password';
                              });
                            },
                            (_) {
                              Navigator.pop(dialogContext, true);
                            },
                          );
                        },
                  child: isVerifying
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    return confirmed ?? false;
  }

  Widget _buildBiometricToggle(BuildContext context, WidgetRef ref, AppLanguage lang) {
    final session = ref.read(userSessionServiceProvider);
    final isEnabled = session.isBiometricLoginEnabled();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.fingerprint, color: context.isDark ? Colors.blue.shade200 : Colors.blue),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('fingerprintLogin', lang),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.appTextPrimary,
                  ),
                ),
                Text(
                  AppStrings.get('unlockWithFingerprint', lang),
                  style: TextStyle(fontSize: 11, color: context.appTextSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) async {
              if (value) {
                final passwordConfirmed =
                    await _confirmPasswordBeforeEnabling(context, ref);

                if (!passwordConfirmed) return;

                final biometricService = ref.read(biometricServiceProvider);
                final canUse = await biometricService.canCheckBiometrics();

                if (!canUse) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No fingerprint set up on this device. Add one in your phone settings first.',
                        ),
                      ),
                    );
                  }
                  return;
                }

                final confirmed = await biometricService.authenticate(
                  reason: 'Confirm your fingerprint to enable fingerprint login',
                );

                if (!confirmed) return;
              }

              await session.setBiometricLoginEnabled(value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle(
    BuildContext context,
    WidgetRef ref,
    AppLanguage lang,
  ) {
    final isNepali = lang == AppLanguage.nepali;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.language,
            color: context.isDark ? Colors.blue.shade200 : Colors.blue,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              AppStrings.get('language', lang),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.appTextPrimary,
              ),
            ),
          ),
          Text(
            isNepali ? 'ने' : 'EN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isNepali,
            onChanged: (value) {
              ref.read(localeViewModelProvider.notifier).setLanguage(
                    value ? AppLanguage.nepali : AppLanguage.english,
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(WidgetRef ref, AppLanguage lang) {
    final themeState = ref.watch(themeViewModelProvider);

    Widget option(AppThemeMode mode, IconData icon, String label) {
      final isSelected = themeState.mode == mode;

      return Expanded(
        child: GestureDetector(
          onTap: () =>
              ref.read(themeViewModelProvider.notifier).setMode(mode),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : context.appTextSecondary,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white : context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.appSurfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          option(AppThemeMode.light, Icons.light_mode, AppStrings.get('light', lang)),
          option(AppThemeMode.dark, Icons.dark_mode, AppStrings.get('dark', lang)),
          option(AppThemeMode.auto, Icons.brightness_auto, AppStrings.get('auto', lang)),
        ],
      ),
    );
  }
}