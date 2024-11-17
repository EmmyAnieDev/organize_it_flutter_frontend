import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../app/constant/colors.dart';
import '../../../../data/providers/task_controller.dart';
import '../../../widgets/overview_diagonal_line.dart';

class TodaysOverview extends ConsumerWidget {
  const TodaysOverview({
    super.key,
  });

  String _formatDate() {
    final now = DateTime.now();
    return DateFormat('d MMM, yyyy').format(now);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  double _calculatePercentage(int completed, int total) {
    if (total == 0) return 0;
    return (completed / total) * 100;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tp = ref.watch(taskProvider);

    // Filter tasks for today
    final todaysTasks =
        tp.tasks.where((task) => _isToday(task.endDate)).toList();

    // Get total tasks for today
    final totalTasks = todaysTasks.length;

    // Get completed tasks for today
    final completedTasks = todaysTasks.where((task) => task.isCompleted).length;

    // Calculate percentage
    final percentage = _calculatePercentage(completedTasks, totalTasks);

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
            _formatDate(),
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
            '$completedTasks/$totalTasks Tasks',
            style: GoogleFonts.montserrat(
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            '${percentage.toInt()}%',
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
