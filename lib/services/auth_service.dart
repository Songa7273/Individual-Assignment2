/// Authentication service for Firebase Auth operations.
/// 
/// Handles all Firebase Authentication and user profile operations including
/// sign up, sign in, sign out, email verification, and user profile management.
/// Acts as an abstraction layer between Firebase and the rest of the app.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// The currently authenticated user (null if not signed in)
  User? get currentUser => _auth.currentUser;
  
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Creates a new user account with email and password.
  /// 
  /// [email] User's email address
  /// [password] User's password (minimum 6 characters for Firebase)
  /// 
  /// Returns null on success, or an error message string on failure.
  /// Automatically sends email verification and creates user profile in Firestore.
  Future<String?> signUp(String email, String password) async {
    try {
      // Create new user account in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        // Send verification email to new user
        await user.sendEmailVerification();
        
        // Create user profile document in Firestore
        UserProfile profile = UserProfile(
          uid: user.uid,
          email: email,
          emailVerified: false,
          createdAt: DateTime.now(),
        );
        
        await _firestore.collection('users').doc(user.uid).set(profile.toMap());
      }
      return null; // Success
    } on FirebaseAuthException catch (e) {
      // Return Firebase error message to user
      return e.message;
    }
  }

  /// Signs in an existing user with email and password.
  /// 
  /// [email] User's email address
  /// [password] User's password
  /// 
  /// Returns null on success, or an error message string on failure.
  /// Verifies that email has been verified before allowing sign in.
  Future<String?> signIn(String email, String password) async {
    try {
      // Authenticate user with Firebase Auth
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Refresh user data to get latest email verification status
      await result.user?.reload();
      
      // Prevent sign-in if email is not verified
      if (result.user != null && !result.user!.emailVerified) {
        return 'Please verify your email before signing in';
      }
      return null; // Success
    } on FirebaseAuthException catch (e) {
      // Return Firebase error message to user
      return e.message;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Sends email verification to the current user.
  /// 
  /// Only sends if user is signed in and email is not already verified.
  Future<void> sendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Retrieves user profile from Firestore.
  /// 
  /// [uid] The user's unique identifier
  /// 
  /// Returns UserProfile if found, null otherwise.
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Updates user's notification preference in Firestore.
  /// 
  /// [uid] The user's unique identifier
  /// [enabled] Whether notifications should be enabled
  Future<void> updateNotificationPreference(String uid, bool enabled) async {
    await _firestore.collection('users').doc(uid).update({
      'notificationsEnabled': enabled,
    });
  }
}
