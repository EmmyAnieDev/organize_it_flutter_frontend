import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organizer_it/app/constant/colors.dart';

import '../../../../data/providers/user_controller.dart';
import '../../../widgets/appbar_icon_butons.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ucp = ref.watch(userProvider);

    return Row(
      children: [
        Text(
          'Hi ${ucp.currentUser!.name}!',
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
