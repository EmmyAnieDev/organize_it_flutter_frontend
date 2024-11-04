import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organizer_it/app/constant/colors.dart';

import '../../../widgets/appbar_icon_butons.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Hi, Adelia',
          style: GoogleFonts.montserrat(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 50,
          ),
        ),
        const Spacer(),
        AppBarIcons(
          icon: Icons.calendar_month_sharp,
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
          },
        ),
        const SizedBox(width: 15),
        AppBarIcons(
          icon: Icons.person_2_outlined,
          onTap: () => context.push('/profile'),
        ),
      ],
    );
  }
}
