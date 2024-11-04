String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null; // Valid input
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null; // Valid input
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 8) {
    return 'Please must be up to 8 characters';
  }
  return null; // Valid input
}

String? validateTaskName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a task name';
  }
  return null;
}

String? validateDates(DateTime? startDate, DateTime? endDate) {
  if (startDate == null) {
    return 'Please select a start date';
  }
  if (endDate == null) {
    return 'Please select an end date';
  }
  if (endDate.isBefore(startDate)) {
    return validateSelectedDate(startDate, endDate);
  }
  return null;
}

String? validateSelectedDate(DateTime? startDate, DateTime? endDate) {
  if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
    return 'End date should be the same as or after the start date';
  }
  return null;
}
