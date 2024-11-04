import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constant/colors.dart';
import '../../../app/router/go_router.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/custom_textformfield.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final fullNameController = TextEditingController();
    final passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                style: GoogleFonts.salsa(
                  fontSize: 40,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                hint: 'Full Name',
                icon: Icons.person,
                controller: fullNameController,
                validator: validateName,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hint: 'Email',
                icon: Icons.email,
                controller: emailController,
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hint: 'Password',
                icon: Icons.lock,
                controller: passwordController,
                isPassword: true,
                validator: validatePassword,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle sign-up logic here
                    // Call your sign-up function with email, full name, and password.
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black, // Match sign-in color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () => router.push("/sign-in"),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: AppColors.lineColor1,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
