import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/constant/colors.dart';
import '../../../widgets/overview_diagonal_line.dart';

class TodaysOverview extends StatelessWidget {
  const TodaysOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '3 Nov, 2024',
            style: GoogleFonts.montserrat(
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            'Today\'s progress',
            style: GoogleFonts.montserrat(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Text(
            '4/12 Tasks',
            style: GoogleFonts.montserrat(
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            '36%',
            style: GoogleFonts.montserrat(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: 50,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: DiagonalProgressLines(),
          )
        ],
      ),
    );
  }
}
