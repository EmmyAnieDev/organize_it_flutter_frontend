import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/constant/colors.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.label,
    required this.onPress,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPress;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isLoading ? AppColors.black.withOpacity(0.7) : AppColors.black,
        foregroundColor: AppColors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
          : Text(
              label,
              style: GoogleFonts.montserrat(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
    );
  }
}
