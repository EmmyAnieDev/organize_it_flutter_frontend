import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../app/constant/colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/providers/task_controller.dart';
import '../../widgets/save_button.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final int taskId;

  const EditTaskScreen({
    super.key,
    required this.taskId,
  });

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch task details when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskProvider).loadTaskDetails(widget.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tp = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Edit Task',
          style: GoogleFonts.salsa(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: tp.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: tp.formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: tp.taskNameController,
                      decoration: const InputDecoration(
                        labelText: 'Task Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: validateTaskName,
                    ),
                    const SizedBox(height: 16.0),
                    ListTile(
                      title: const Text('Start Date'),
                      subtitle: Text(
                        tp.startDate == null
                            ? 'Select start date'
                            : DateFormat.yMMMd().format(tp.startDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => tp.selectDate(context, true),
                    ),
                    const SizedBox(height: 16.0),
                    ListTile(
                      title: const Text('End Date'),
                      subtitle: Text(
                        tp.endDate == null
                            ? 'Select end date'
                            : DateFormat.yMMMd().format(tp.endDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => tp.selectDate(context, false),
                    ),
                    if (validateDates(tp.startDate, tp.endDate) != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                        child: Text(
                          validateDates(tp.startDate, tp.endDate)!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: tp.categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    SaveButton(
                      label: 'Save Changes',
                      onPress: () => tp.updateTask(context, widget.taskId, ref),
                      isLoading: tp.isLoading,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
