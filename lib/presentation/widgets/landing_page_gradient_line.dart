import 'package:flutter/material.dart';

import '../../app/constant/colors.dart';

class GradientLine extends StatelessWidget {
  final int index;
  final double width;

  const GradientLine(this.index, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: index * 10.0),
      height: 7,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lineColor1.withOpacity(1 - index * 0.15),
            AppColors.lineColor2.withOpacity(1 - index * 0.15),
            AppColors.lineColor3.withOpacity(1 - index * 0.15),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
