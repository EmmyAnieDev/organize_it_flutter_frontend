import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constant/colors.dart';
import '../../widgets/edit_profile_button.dart';
import '../../widgets/profile_text_field.dart';
import '../../widgets/save_button.dart';
import 'components/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController(text: 'John Doe');
  final emailController = TextEditingController(text: 'john.doe@example.com');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://ui-avatars.com/api/?name=John+Doe&size=120',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: EditProfileButton(
                      onImageSelected: (file) {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ProfileTextField(
              nameController: nameController,
              labelText: 'Full Name',
            ),
            const SizedBox(height: 16),
            ProfileTextField(
              nameController: emailController,
              labelText: 'Email',
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SaveButton(
                label: 'Save Changes',
                onPress: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Spacer(),
            LogoutButton()
          ],
        ),
      ),
    );
  }
}
