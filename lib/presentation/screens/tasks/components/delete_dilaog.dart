import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/constant/colors.dart';
import '../../../../data/providers/task_controller.dart';

class DeleteDialog extends ConsumerWidget {
  final int taskId;

  const DeleteDialog({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(
        'Delete Task',
        style: GoogleFonts.salsa(
          color: AppColors.black,
          fontWeight: FontWeight.w500,
          fontSize: 25,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this task?',
        style: GoogleFonts.montserrat(
          color: AppColors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.salsa(
              color: AppColors.lineColor1,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            ref.read(taskProvider).deleteTask(taskId, context, ref);
            Navigator.pop(context);
            ref.read(taskProvider).fetchTasks(ref);
          },
          child: Text(
            'Delete',
            style: GoogleFonts.salsa(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
