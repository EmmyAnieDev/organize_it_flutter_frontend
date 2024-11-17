import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organizer_it/data/providers/user_controller.dart';

import '../../../app/constant/colors.dart';
import '../../widgets/edit_profile_button.dart';
import '../../widgets/profile_text_field.dart';
import '../../widgets/save_button.dart';
import 'components/logout_button.dart';
import 'components/profile_photo.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ucp = ref.read(userProvider);
      final currentUser = ucp.currentUser;
      if (currentUser != null) {
        ucp.nameController.text = currentUser.name;
        ucp.emailController.text = currentUser.email;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ucp = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.salsa(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
        actions: const [LogoutButton()],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Stack(
                  children: [
                    const ProfilePhoto(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: EditProfileButton(
                        onImageSelected: (file) =>
                            ucp.selectAndUploadPhoto(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ProfileTextField(
                nameController: ucp.nameController,
                labelText: 'Name',
              ),
              const SizedBox(height: 16),
              ProfileTextField(
                nameController: ucp.emailController,
                labelText: 'Email',
              ),
              const SizedBox(height: 16),
              ProfileTextField(
                nameController: ucp.passwordController,
                labelText: 'Password',
              ),
              const SizedBox(height: 24),
              if (ucp.isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: CircularProgressIndicator(color: AppColors.black),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SaveButton(
                  label: 'Save Changes',
                  onPress: () => ucp.updateUserProfile(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
