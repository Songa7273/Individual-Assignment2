/// Application-wide constants used throughout the app.
/// 
/// Contains configuration values, default coordinates, and predefined
/// categories that are used across multiple screens and services.
class AppConstants {
  /// The display name of the application
  static const String appName = 'Kigali Services Directory';
  
  /// Default latitude for Kigali city center
  /// Used as the initial map center and default location
  static const double kigaliLatitude = -1.9441;
  
  /// Default longitude for Kigali city center
  /// Used as the initial map center and default location
  static const double kigaliLongitude = 30.0619;
  
  /// List of available service categories for filtering and classification
  /// 'All' is used as a special category to show unfiltered results
  static const List<String> categories = [
    'All',
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
  ];
}
