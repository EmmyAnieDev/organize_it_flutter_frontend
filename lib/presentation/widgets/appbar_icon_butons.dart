import 'package:flutter/material.dart';

import '../../app/constant/colors.dart';

class AppBarIcons extends StatelessWidget {
  const AppBarIcons({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.lightGrey),
          child: Icon(
            icon,
            size: 24,
          )),
    );
  }
}
