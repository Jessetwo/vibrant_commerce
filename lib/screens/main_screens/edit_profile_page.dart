import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vibrant_commerce/components/assets/app_colors.dart';
import 'package:vibrant_commerce/components/widgets/my_button.dart';
import 'package:vibrant_commerce/components/widgets/my_text_box.dart';
import 'package:vibrant_commerce/providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String _currentAvatarUrl = '';
  File? _pickedAvatarFile;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _currentAvatarUrl = user.avatar;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        _pickedAvatarFile = File(picked.path);
      });
    }
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Email cannot be empty.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    String avatarUrl = _currentAvatarUrl;

    if (_pickedAvatarFile != null) {
      // ── Upload new avatar image to Imgbb ──────────────────
      const imgbbApiKey = 'e5b38c050bd74827b767cb5f30946802';
      try {
        final bytes = await _pickedAvatarFile!.readAsBytes();
        final base64Str = base64Encode(bytes);

        final uploadResponse = await http.post(
          Uri.parse('https://api.imgbb.com/1/upload?key=$imgbbApiKey'),
          body: {'image': base64Str},
        );

        if (uploadResponse.statusCode == 200) {
          final data = json.decode(uploadResponse.body);
          final url = data['data']['url'] as String?;
          if (url != null && url.isNotEmpty) {
            avatarUrl = url;
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload image. Using previous avatar.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error uploading image. Using previous avatar.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.updateUserProfile(
      name: name,
      email: email,
      avatar: avatarUrl.isNotEmpty ? avatarUrl : null,
    );

    if (!mounted) return;
    setState(() => _isUploading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Failed to update profile.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.tertiaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Personal Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00113A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep your profile information up to date',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            border: Border.all(
                              color: AppColors.primaryColor.withValues(alpha: 0.2),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                            image: DecorationImage(
                              image: _pickedAvatarFile != null
                                  ? FileImage(_pickedAvatarFile!)
                                  : (_currentAvatarUrl.isNotEmpty
                                      ? (_currentAvatarUrl.startsWith('http://') ||
                                              _currentAvatarUrl.startsWith('https://')
                                          ? NetworkImage(_currentAvatarUrl)
                                          : AssetImage(_currentAvatarUrl) as ImageProvider)
                                      : const AssetImage('assets/images/avatar.png')),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: _pickAvatar,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  MyTextBox(
                    title: 'Full Name',
                    hintText: 'Enter your name',
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  MyTextBox(
                    title: 'Email Address',
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 32),
                  _isUploading || isLoading
                      ? Center(
                          child: Column(
                            children: [
                              const CircularProgressIndicator(),
                              if (_isUploading) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Uploading profile picture...',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : MyButton(
                          title: 'Save Changes',
                          onPressed: _handleSave,
                          color: AppColors.primaryColor,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
