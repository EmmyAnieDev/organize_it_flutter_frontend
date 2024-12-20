import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../app/constant/colors.dart';
import '../../data/providers/task_controller.dart';
import '../screens/tasks/components/delete_dilaog.dart';
import 'edit_delete_task_button.dart';

class TaskCard extends ConsumerWidget {
  final int taskId;
  final String title;
  final String category;
  final DateTime dueDate;
  final DateTime endDate;
  final String status;

  const TaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.status,
    required this.endDate,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tp = ref.watch(taskProvider);
    final isSelected = tp.isTaskSelected(taskId);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text("Category: $category",
                style: const TextStyle(color: AppColors.lineColor1)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Due date: ${DateFormat('yyyy-MM-dd').format(dueDate)}",
                  style: TextStyle(color: AppColors.black.withOpacity(0.8)),
                ),
                Text(
                  "End date: ${DateFormat('yyyy-MM-dd').format(endDate)}",
                  style: TextStyle(color: AppColors.black.withOpacity(0.8)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    tp.toggleTaskSelection(taskId);
                  },
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  color: status == "Completed" ? Colors.green : Colors.orange,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  status,
                  style: TextStyle(
                    color: status == "Completed" ? Colors.green : Colors.orange,
                  ),
                ),
                const Spacer(),
                EditDeleteTaskButton(
                  icon: Icons.edit_note_outlined,
                  onTap: () => context.push('/edit-task/$taskId'),
                  color: Colors.blue,
                ),
                const SizedBox(width: 15),
                EditDeleteTaskButton(
                  icon: Icons.delete,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DeleteDialog(taskId: taskId);
                      },
                    );
                  },
                  color: Colors.red,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 1,
              color: AppColors.lightGrey,
            )
          ],
        ),
      ),
    );
  }
}
