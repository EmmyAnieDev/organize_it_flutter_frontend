import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constant/colors.dart';
import '../../../data/providers/task_controller.dart';
import '../../widgets/filter_buttons.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/task_card.dart';
import 'components/custom_appbar.dart';
import 'components/todays_overview.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch tasks when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskProvider).fetchTasks(ref).then((_) {
        final tasks = ref.read(taskProvider).tasks;
        print("Fetched Tasks: $tasks");
      }).catchError((error) {
        print("Error fetching tasks: $error");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tp = ref.watch(taskProvider);
    final tasks = tp.filteredTasks;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  CustomAppBar(),
                  SizedBox(height: 10),
                  SearchTextField(),
                ],
              ),
            ),
            tp.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        const TodaysOverview(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Filter By',
                              style: GoogleFonts.salsa(
                                color: AppColors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Icon(Icons.filter_list_rounded),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilterButtons(
                              label: 'Categories',
                              filterType: FilterType.category,
                              onTap: () => tp.setCategoryFilter("Work"),
                            ),
                            FilterButtons(
                              label: 'Date',
                              icon: Icons.calendar_month,
                              filterType: FilterType.date,
                              onTap: () => tp.setDateFilter(DateTime.now()),
                            ),
                            FilterButtons(
                              label: 'Status',
                              filterType: FilterType.status,
                              onTap: () => tp.setStatusFilter("Completed"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        if (tp.hasFilters)
                          TextButton(
                            onPressed: tp.clearFilters,
                            child: const Text(
                              "Clear Filters",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        tasks.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Text(
                                    'No tasks available',
                                    style: GoogleFonts.salsa(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: tasks
                                    .map((task) => TaskCard(
                                          title: task.name,
                                          category: task.category?.toString() ??
                                              'Uncategorized',
                                          dueDate: task.startDate,
                                          endDate: task.endDate,
                                          status: task.isCompleted
                                              ? 'Completed'
                                              : 'Pending',
                                        ))
                                    .toList(),
                              ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-task');
          print('Add task button pressed');
        },
        backgroundColor: AppColors.lineColor1,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
