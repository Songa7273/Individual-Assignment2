/// Main entry point for the Kigali Services Directory application.
/// 
/// This file initializes Firebase, sets up state management providers,
/// and configures the app theme and routing.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/listings_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';

/// Application entry point.
/// 
/// Initializes Flutter bindings and Firebase before running the app.
/// The async main function ensures all setup is complete before widget rendering.
void main() async {
  // Ensures that plugin services are initialized before app startup
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase for authentication and Firestore database
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

/// Root widget of the application.
/// 
/// Sets up MultiProvider for state management and configures the Material theme.
/// Provides access to AuthProvider and ListingsProvider throughout the widget tree.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set up multiple providers for dependency injection
    return MultiProvider(
      providers: [
        // Manages authentication state and user operations
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Manages service listings data and operations
        ChangeNotifierProvider(create: (_) => ListingsProvider()),
      ],
      child: MaterialApp(
        title: 'Kigali Services Directory',
        debugShowCheckedModeBanner: false,
        
        // Configure Material 3 theme with custom colors and styles
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          
          // Consistent app bar styling across all screens
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          
          // Input field styling with light gray background
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          
          // Elevated button styling with rounded corners
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        
        // Use AuthWrapper to determine initial route based on auth state
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Authentication wrapper widget that determines which screen to show.
/// 
/// Listens to the AuthProvider and displays either the HomeScreen (if authenticated)
/// or the LoginScreen (if not authenticated). This provides automatic navigation
/// based on authentication state changes.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes and rebuild when authentication status changes
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show home screen if user is authenticated, otherwise show login
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
