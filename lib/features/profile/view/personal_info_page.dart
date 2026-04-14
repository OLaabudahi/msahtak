import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/app_assets.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  bool emailSent = false;
  final _controller = TextEditingController();
  final _picker = ImagePicker();

  Future<void> _pickAndUploadProfileImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null || !mounted) return;
    context.read<ProfileBloc>().add(ProfileAvatarUploadRequested(file));
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(CheckEmailVerifiedRequested());

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: Text(context.t('personalInfo'))),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user!;
          final ifValid = user.isEmailVerified;
          final ifSend = emailSent && !user.isEmailVerified;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(CheckEmailVerifiedRequested());
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickAndUploadProfileImage,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                        child:
                            user.avatarUrl == null ? Image.asset(AppAssets.logo, width: 25) : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Expanded(child: Text(user.email)),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: ifValid ? AppColors.success : AppColors.textMuted,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  ifValid ? Icons.check : Icons.close,
                                  color: AppColors.background,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _tile(
                  icon: Icons.person,
                  title: context.t('fullName'),
                  value: user.fullName,
                  onTap: () => _editDialog(
                    context,
                    title: context.t('profileEditNameTitle'),
                    initial: user.fullName,
                    validator: _validateName,
                    onSave: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfileRequested(
                              name: value,
                              email: user.email,
                              phone: user.phoneNumber ?? '',
                            ),
                          );
                    },
                  ),
                ),
                _tile(
                  icon: Icons.email,
                  title: context.t('email'),
                  value: user.email,
                  onTap: () => _editDialog(
                    context,
                    title: context.t('profileEditEmailTitle'),
                    initial: user.email,
                    validator: _validateEmail,
                    onSave: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfileRequested(
                              name: user.fullName,
                              email: value,
                              phone: user.phoneNumber ?? '',
                            ),
                          );
                    },
                  ),
                ),
                if (ifSend && !ifValid)
                  Text(
                    context.t('profileVerificationSentHint'),
                    style: const TextStyle(color: AppColors.warningText),
                  ),
                if (!ifSend && !ifValid)
                  TextButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(const VerifyEmailRequested());
                      setState(() => emailSent = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.t('profileVerificationEmailSent'))),
                      );
                    },
                    child: Text(context.t('profileVerifyEmailButton')),
                  ),
                _tile(
                  icon: Icons.phone,
                  title: context.t('phoneNumber'),
                  value: user.phoneNumber ?? context.t('profileAddPhone'),
                  onTap: () => _editDialog(
                    context,
                    title: context.t('profileEditPhoneTitle'),
                    initial: user.phoneNumber ?? '',
                    validator: _validatePhone,
                    onSave: (value) {
                      context.read<ProfileBloc>().add(
                            UpdateProfileRequested(
                              name: user.fullName,
                              email: user.email,
                              phone: value,
                            ),
                          );
                    },
                  ),
                ),
                _tile(
                  icon: Icons.lock,
                  title: context.t('password'),
                  value: '••••••••',
                  onTap: () {
                    context.read<ProfileBloc>().add(const ChangePasswordRequested());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.t('profileResetPasswordHint'))),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, size: 26),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _editDialog(
    BuildContext context, {
    required String title,
    required String initial,
    required String? Function(String)? validator,
    required Function(String) onSave,
  }) {
    _controller.text = initial;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            validator: (v) => validator?.call(v ?? ''),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                onSave(_controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text(context.t('saveChanges')),
          ),
        ],
      ),
    );
  }

  String? _validateName(String v) {
    if (v.isEmpty) return context.t('fieldRequired');
    if (v.length < 3) return context.t('fieldTooShort');
    return null;
  }

  String? _validateEmail(String v) {
    if (v.isEmpty) return context.t('fieldRequired');
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
      return context.t('invalidEmail');
    }
    return null;
  }

  String? _validatePhone(String v) {
    if (v.isEmpty) return context.t('fieldRequired');
    if (v.length < 8) return context.t('invalidPhone');
    return null;
  }
}
