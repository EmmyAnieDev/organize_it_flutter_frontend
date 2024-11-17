import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/constant/colors.dart';
import '../../../../data/providers/task_controller.dart';

class CompleteButton extends ConsumerWidget {
  const CompleteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tp = ref.watch(taskProvider);

    return Center(
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: AppColors.lineColor1,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${tp.selectedTasks.length} selected',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Complete Tasks'),
                      content: Text(
                          'Are you sure you want to mark ${tp.selectedTasks.length} tasks as completed?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            tp.completeSelectedTasks(ref);
                          },
                          child: const Text('Complete'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.lineColor1,
                ),
                child: const Text('Complete'),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: tp.clearSelection,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
