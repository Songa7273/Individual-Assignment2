/// Authentication provider for managing user authentication state.
/// 
/// This provider handles user sign-in, sign-up, sign-out operations
/// and maintains the current authentication state throughout the app.
/// Uses ChangeNotifier to notify listeners of state changes.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // Private state variables
  User? _user;
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Public getters for accessing state
  
  /// Currently authenticated Firebase user
  User? get user => _user;
  
  /// User profile data from Firestore
  UserProfile? get userProfile => _userProfile;
  
  /// Whether an authentication operation is in progress
  bool get isLoading => _isLoading;
  
  /// Current error message, if any
  String? get errorMessage => _errorMessage;
  
  /// Whether user is authenticated and email is verified
  bool get isAuthenticated => _user != null && (_user?.emailVerified ?? false);

  /// Constructor that sets up authentication state listener.
  /// 
  /// Listens to Firebase auth state changes and updates the provider accordingly.
  /// Loads user profile when a user signs in.
  AuthProvider() {
    // Listen to auth state changes from Firebase
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        // Load user profile when user signs in
        _loadUserProfile(user.uid);
      } else {
        // Clear profile when user signs out
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  /// Loads user profile data from Firestore.
  /// 
  /// [uid] The user's unique identifier
  Future<void> _loadUserProfile(String uid) async {
    _userProfile = await _authService.getUserProfile(uid);
    notifyListeners();
  }

  /// Creates a new user account with email and password.
  /// 
  /// [email] User's email address
  /// [password] User's password (must meet Firebase requirements)
  /// 
  /// Returns true if sign-up was successful, false otherwise.
  /// Sets [errorMessage] if an error occurs.
  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? error = await _authService.signUp(email, password);
    
    _isLoading = false;
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }
    
    notifyListeners();
    return true;
  }

  /// Signs in an existing user with email and password.
  /// 
  /// [email] User's email address
  /// [password] User's password
  /// 
  /// Returns true if sign-in was successful, false otherwise.
  /// Sets [errorMessage] if an error occurs or email is not verified.
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? error = await _authService.signIn(email, password);
    
    _isLoading = false;
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }
    
    notifyListeners();
    return true;
  }

  /// Signs out the current user.
  /// 
  /// Clears user and profile data from the provider.
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _userProfile = null;
    notifyListeners();
  }

  /// Sends email verification to the current user.
  /// 
  /// Should be called after sign-up or if user needs to reverify their email.
  Future<void> sendVerificationEmail() async {
    await _authService.sendVerificationEmail();
  }

  /// Updates user's notification preference.
  /// 
  /// [enabled] Whether notifications should be enabled
  Future<void> updateNotificationPreference(bool enabled) async {
    if (_user != null) {
      await _authService.updateNotificationPreference(_user!.uid, enabled);
      await _loadUserProfile(_user!.uid);
    }
  }

  /// Clears any error message in the provider.
  /// 
  /// Should be called when dismissing error dialogs or before new operations.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
