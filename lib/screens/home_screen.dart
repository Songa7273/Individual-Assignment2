/// Main home screen with bottom navigation.
/// 
/// Displays four main sections accessible via bottom navigation:
/// - Directory: Browse all service listings
/// - My Listings: View and manage user's own listings
/// - Map View: See listings on a map
/// - Settings: App settings and user preferences
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/listings_provider.dart';
import 'directory/directory_screen.dart';
import 'my_listings/my_listings_screen.dart';
import 'map/map_view_screen.dart';
import 'settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Current selected tab index (0-3)
  int _currentIndex = 0;

  /// List of screens corresponding to each bottom nav tab
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    
    // Initialize the four main screens
    _screens = [
      const DirectoryScreen(),
      const MyListingsScreen(),
      const MapViewScreen(),
      const SettingsScreen(),
    ];
    
    // Set up data listeners after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final listingsProvider = Provider.of<ListingsProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Start listening to all listings for directory view
      listingsProvider.listenToAllListings();
      
      // Start listening to user's own listings if authenticated
      if (authProvider.user != null) {
        listingsProvider.listenToUserListings(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the currently selected screen
      body: _screens[_currentIndex],
      
      // Bottom navigation bar with 4 tabs
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Directory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_location),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
