import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organizer_it/app/router/go_router.dart';
import 'package:organizer_it/data/providers/user_controller.dart';

import '../../../app/constant/colors.dart';
import '../../widgets/landing_page_gradient_line.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ucp = ref.watch(userProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.black,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 120),
                Column(
                  children: [
                    for (var i = 0; i < 6; i++) GradientLine(i, 250 - i * 15.0),
                  ],
                ),
                Column(
                  children: [
                    for (var i = 0; i < 6; i++) GradientLine(i, 150 + i * 30.0),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 400,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage',
                      style: GoogleFonts.salsa(
                        fontSize: 65,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'your',
                      style: GoogleFonts.salsa(
                        fontSize: 55,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'tasks',
                        style: GoogleFonts.salsa(
                          fontSize: 65,
                          color: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Get started',
                          style: GoogleFonts.montserrat(
                            fontSize: 35,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            onPressed: () {
                              ucp.currentUser != null
                                  ? router.push("/task-screen")
                                  : router.push("/sign-in");
                            },
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
