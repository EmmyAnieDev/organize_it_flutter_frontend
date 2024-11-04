import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../app/constant/colors.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/save_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    final dateError = validateDates(_startDate, _endDate);
    if (_formKey.currentState!.validate() && dateError == null) {
      // If all fields are valid, submit the form
      Navigator.pop(context);
    } else {
      // If date validation fails, show an error message
      setState(() {});
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Add Task',
          style: GoogleFonts.salsa(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _taskNameController,
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
                  _startDate == null
                      ? 'Select start date'
                      : DateFormat.yMMMd().format(_startDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(
                  _endDate == null
                      ? 'Select end date'
                      : DateFormat.yMMMd().format(_endDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              if (validateDates(_startDate, _endDate) != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Text(
                    validateDates(_startDate, _endDate)!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              SaveButton(
                label: 'Add Task',
                onPress: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
