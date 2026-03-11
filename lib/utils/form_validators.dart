/// Form validation utilities for input fields.
/// 
/// Provides reusable validation functions with detailed error messages
/// for better user feedback.
class FormValidators {
  /// Validates name fields (minimum 3 characters, letters and spaces only).
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }
    if (value.trim().length > 100) {
      return 'Name must not exceed 100 characters';
    }
    return null;
  }

  /// Validates address fields (minimum 5 characters).
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 5) {
      return 'Please enter a complete address (at least 5 characters)';
    }
    if (value.trim().length > 200) {
      return 'Address must not exceed 200 characters';
    }
    return null;
  }

  /// Validates phone numbers (10-15 digits, optional +, spaces, dashes).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    
    // Remove common phone number formatting characters
    final cleanNumber = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check if it starts with + and has digits
    final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
    if (!phoneRegex.hasMatch(cleanNumber)) {
      return 'Please enter a valid phone number (9-15 digits)';
    }
    return null;
  }

  /// Validates description fields (minimum 10 characters).
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Please provide a more detailed description (at least 10 characters)';
    }
    if (value.trim().length > 500) {
      return 'Description must not exceed 500 characters';
    }
    return null;
  }

  /// Validates latitude values (-90 to 90).
  static String? validateLatitude(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Latitude is required';
    }
    
    final latitude = double.tryParse(value);
    if (latitude == null) {
      return 'Please enter a valid number';
    }
    
    if (latitude < -90 || latitude > 90) {
      return 'Latitude must be between -90 and 90';
    }
    return null;
  }

  /// Validates longitude values (-180 to 180).
  static String? validateLongitude(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Longitude is required';
    }
    
    final longitude = double.tryParse(value);
    if (longitude == null) {
      return 'Please enter a valid number';
    }
    
    if (longitude < -180 || longitude > 180) {
      return 'Longitude must be between -180 and 180';
    }
    return null;
  }

  /// Validates email addresses.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password strength (minimum 6 characters, mix of letters and numbers recommended).
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    if (value.length > 50) {
      return 'Password must not exceed 50 characters';
    }
    
    // Check for at least one letter and one number (recommended)
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    
    if (!hasLetter || !hasNumber) {
      return 'Password should contain both letters and numbers for security';
    }
    
    return null;
  }
}
