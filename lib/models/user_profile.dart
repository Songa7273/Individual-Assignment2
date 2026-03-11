/// Data model representing a user profile in the application.
/// 
/// Stores user account information including authentication status,
/// preferences, and account creation timestamp.
class UserProfile {
  /// Unique user identifier from Firebase Authentication
  final String uid;
  
  /// User's email address
  final String email;
  
  /// Whether the user's email has been verified
  final bool emailVerified;
  
  /// User preference for receiving notifications (default: true)
  final bool notificationsEnabled;
  
  /// Timestamp when the user account was created
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.emailVerified,
    this.notificationsEnabled = true,
    required this.createdAt,
  });

  /// Converts the UserProfile object to a Map for Firestore storage.
  /// 
  /// Timestamp is converted to ISO 8601 string format for consistent storage.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'emailVerified': emailVerified,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creates a UserProfile object from Firestore document data.
  /// 
  /// [map] The document data as a Map
  /// 
  /// Provides default values for missing fields to prevent null errors.
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      emailVerified: map['emailVerified'] ?? false,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
