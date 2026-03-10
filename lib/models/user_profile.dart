class UserProfile {
  final String uid;
  final String email;
  final bool emailVerified;
  final bool notificationsEnabled;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.emailVerified,
    this.notificationsEnabled = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'emailVerified': emailVerified,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

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
