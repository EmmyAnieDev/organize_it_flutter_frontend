import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constant/colors.dart';
import '../../widgets/filter_buttons.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/task_card.dart';
import 'components/custom_appbar.dart';
import 'components/todays_overview.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String? _selectedCategory;
  String? _selectedStatus;
  DateTime? _selectedDate;

  final List<Map<String, String>> tasks = [
    {
      "title": "Task 1",
      "category": "Work",
      "dueDate": "2024-11-02",
      "status": "Completed"
    },
    {
      "title": "Task 2",
      "category": "Personal",
      "dueDate": "2024-11-03",
      "status": "Pending"
    },
    {
      "title": "Task 3",
      "category": "Work",
      "dueDate": "2024-11-04",
      "status": "In Progress"
    },
  ];

  List<Map<String, String>> get filteredTasks {
    if (_selectedCategory == null) {
      return tasks;
    }
    return tasks
        .where((task) => task["category"] == _selectedCategory)
        .toList();
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _selectStatus(String status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
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
                      const Icon(Icons.filter_list_rounded)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterButtons(
                        label: 'Categories',
                        filterType: FilterType.category,
                        onTap: () => _selectCategory("Work"),
                      ),
                      FilterButtons(
                        label: 'Date',
                        icon: Icons.calendar_month,
                        filterType: FilterType.date,
                        onTap: () => _selectDate(DateTime.now()),
                      ),
                      FilterButtons(
                        label: 'Status',
                        filterType: FilterType.status,
                        onTap: () => _selectStatus("Completed"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (_selectedCategory != null ||
                      _selectedStatus != null ||
                      _selectedDate != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                          _selectedStatus = null;
                          _selectedDate = null;
                        });
                      },
                      child: const Text(
                        "Clear Filters",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ...filteredTasks.map((task) => TaskCard(
                        title: task["title"]!,
                        category: task["category"]!,
                        dueDate: task["dueDate"]!,
                        status: task["status"]!,
                      )),
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
