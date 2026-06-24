import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';
import 'package:sikhsha_sathi/features/auth/presentation/pages/login_view.dart';
import 'package:sikhsha_sathi/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:sikhsha_sathi/features/profile/presentation/state/profile_state.dart';

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

    final profileState =
        ref.watch(profileViewModelProvider);

    final fullName =
        session.getFullName() ??
            "Unknown User";

    final email =
        session.getEmail() ??
            "No Email";

    final phone =
        session.getPhoneNumber() ??
            "No Phone";

    return Scaffold(
      backgroundColor:
          Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(
                top: 60,
                bottom: 20,
              ),
              decoration:
                  const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Center(
                child: Text(
                  "Profile",
                  style: TextStyle(
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
                        Colors.white,
                    backgroundImage:
                        _selectedImage != null
                            ? FileImage(
                                _selectedImage!,
                              )
                            : savedProfilePicture != null
                                ? NetworkImage(
                                    savedProfilePicture,
                                  )
                                : null,
                    child:
                        _selectedImage == null &&
                                savedProfilePicture == null
                            ? const Icon(
                                Icons.person,
                                size: 80,
                                color:
                                    Colors.grey,
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
                    Colors.grey.shade700,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 30),

            _profileTile(
              Icons.person_outline,
              "Full Name",
              fullName,
            ),

            _profileTile(
              Icons.email_outlined,
              "Email",
              email,
            ),

            _profileTile(
              Icons.phone_outlined,
              "Phone Number",
              phone,
            ),

            const SizedBox(height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon:
                      const Icon(Icons.edit),
                  label: const Text(
                    "Edit Profile",
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
                    await session
                        .clearSession();

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
                  label: const Text(
                    "Logout",
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
        color: Colors.white,
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
                      const TextStyle(
                    color: Colors.grey,
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
}