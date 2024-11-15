import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/constant/colors.dart';

class FilterButtons extends StatelessWidget {
  const FilterButtons({
    super.key,
    required this.label,
    this.icon,
    required this.onTap,
    this.filterType = FilterType.category,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final FilterType filterType;

  void _showFilterOptions(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);

    switch (filterType) {
      case FilterType.category:
        _showCategoryDropdown(context, offset, button.size);
        break;
      case FilterType.status:
        _showStatusDropdown(context, offset, button.size);
        break;
      case FilterType.date:
        _showDatePicker(context);
        break;
    }
  }

  void _showCategoryDropdown(BuildContext context, Offset offset, Size size) {
    final categories = ['Work', 'Personal', 'Shopping', 'Health', 'Study'];

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height + 200,
      ),
      items: categories.map((String category) {
        return PopupMenuItem<String>(
          value: category,
          child: Text(
            category,
            style: GoogleFonts.salsa(fontSize: 16),
          ),
        );
      }).toList(),
    ).then((String? selectedCategory) {
      if (selectedCategory != null) {
        onTap();
      }
    });
  }

  void _showStatusDropdown(BuildContext context, Offset offset, Size size) {
    final statuses = ['Completed', 'Pending'];

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height + 200,
      ),
      items: statuses.map((String status) {
        return PopupMenuItem<String>(
          value: status,
          child: Text(
            status,
            style: GoogleFonts.salsa(fontSize: 16),
          ),
        );
      }).toList(),
    ).then((String? selectedStatus) {
      if (selectedStatus != null) {
        onTap();
      }
    });
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    ).then((DateTime? selectedDate) {
      if (selectedDate != null) {
        onTap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showFilterOptions(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.black.withOpacity(0.9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.salsa(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 10),
              Icon(
                icon,
                color: AppColors.white,
                size: 18,
              )
            ],
          ],
        ),
      ),
    );
  }
}

enum FilterType {
  category,
  status,
  date,
}
