import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constant/colors.dart';
import '../../../app/router/go_router.dart';
import '../../../core/utils/validators.dart';
import '../../../data/providers/user_controller.dart';
import '../../widgets/custom_textformfield.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usp = ref.watch(userProvider);
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
                'Sign In',
                style: GoogleFonts.salsa(
                  fontSize: 40,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                hint: 'Email',
                icon: Icons.email,
                controller: usp.emailController,
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hint: 'Password',
                icon: Icons.lock,
                controller: usp.passwordController,
                isPassword: true,
                validator: validatePassword,
              ),
              const SizedBox(height: 32),
              if (usp.isLoading)
                const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.lineColor1))
              else
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      usp.loginUser(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Center(
                      child: Text(
                        'Login',
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
                    'Don’t have an account? ',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () => router.push("/sign-up"),
                    child: Text(
                      'Sign Up',
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
