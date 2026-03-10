# Kigali City Services & Places Directory

A comprehensive Flutter mobile application for locating and navigating to essential public services and leisure locations in Kigali, Rwanda.

## Features

### Authentication
- Firebase Authentication with email and password
- Email verification enforcement before access
- User profile creation and management in Firestore

### Location Listings Management (CRUD)
- **Create**: Add new service/place listings with complete details
- **Read**: Browse all listings in a shared directory
- **Update**: Edit listings you created
- **Delete**: Remove your listings
- Real-time updates across all screens

### Search and Filtering
- Search listings by name
- Filter by category (Hospital, Police Station, Library, Restaurant, Café, Park, Tourist Attraction)
- Dynamic updates as Firestore data changes

### Map Integration
- Embedded Google Maps on detail pages
- Interactive map view showing all listings
- Color-coded markers by category
- Turn-by-turn navigation to selected locations

### User Interface
- Bottom navigation with 4 screens:
  - Directory (Browse all listings)
  - My Listings (Manage your listings)
  - Map View (See all locations on map)
  - Settings (Profile and preferences)

## Technical Architecture

### State Management
This app uses **Provider** for state management with a clean separation of concerns:

- **AuthProvider**: Manages authentication state, user profile, and auth operations
- **ListingsProvider**: Handles Firestore CRUD operations, search, and filtering

### Project Structure
```
lib/
├── models/
│   ├── user_profile.dart       # User data model
│   └── service_listing.dart    # Listing data model
├── services/
│   ├── auth_service.dart       # Firebase Auth operations
│   └── firestore_service.dart  # Firestore CRUD operations
├── providers/
│   ├── auth_provider.dart      # Authentication state management
│   └── listings_provider.dart  # Listings state management
└── screens/
    ├── auth/
    │   ├── login_screen.dart
    │   └── signup_screen.dart
    ├── directory/
    │   └── directory_screen.dart
    ├── my_listings/
    │   ├── my_listings_screen.dart
    │   └── add_edit_listing_screen.dart
    ├── map/
    │   └── map_view_screen.dart
    ├── detail/
    │   └── detail_screen.dart
    ├── settings/
    │   └── settings_screen.dart
    └── home_screen.dart
```

### Firestore Database Structure

#### Collections

**users/** (User Profiles)
```json
{
  "uid": "string",
  "email": "string",
  "emailVerified": "boolean",
  "notificationsEnabled": "boolean",
  "createdAt": "timestamp"
}
```

**listings/** (Service/Place Listings)
```json
{
  "name": "string",
  "category": "string",
  "address": "string",
  "contactNumber": "string",
  "description": "string",
  "latitude": "double",
  "longitude": "double",
  "createdBy": "string (user UID)",
  "timestamp": "timestamp"
}
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Firebase project with Authentication and Firestore enabled
- Google Maps API key

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Songa7273/Individual-Assignment2.git
cd Individual-Assignment2
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a Firebase project at https://console.firebase.google.com
   - Add an Android app with package name: `com.kigali.services.directory`
   - Download `google-services.json` and place it in `android/app/`
   - For iOS: Download `GoogleService-Info.plist` and place it in `ios/Runner/`
   - Enable Authentication → Email/Password
   - Create Firestore Database in production mode

4. Add Google Maps API key:
   - Get API key from Google Cloud Console
   - Enable Maps SDK for Android
   - Open `android/app/src/main/AndroidManifest.xml`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key

5. Run the app:
```bashstore Security Rules

After creating your Firestore database, add these security rules in the Firebase Console (Firestore Database → Rules)
1. Create a Firebase project at https://console.firebase.google.com
2. Enable **Email/Password Authentication**
3. Create a **Cloud Firestore database** in production mode
4. Add security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.resource.data.createdBy == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.createdBy == request.auth.uid;
    }
  }
}
```

## Dependencies

- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Cloud database
- `provider`: State management
- `google_maps_flutter`: Map integration
- `url_launcher`: External navigation

## Design Decisions

### Why Provider?
Provider was chosen for state management because:
- Simple to implement and understand
- Built-in support for ChangeNotifier
- Excellent integration with Firebase streams
- Minimal boilerplate compared to alternatives
- Perfect for this app's complexity level

### Architecture Pattern
A layered architecture was implemented:
1. **Models**: Data structures
2. **Services**: Firebase interaction layer
3. **Providers**: State management and business logic
4. **Screens**: UI components

This ensures:
- Clear separation of concerns
- Easy testing and maintenance
- Scalability for future features

### Real-time Updates
Firestore streams are used to automatically update the UI when data changes, providing a responsive user experience without manual refreshes.

## Known Limitations

- Google Maps API key needs to be configured for maps to work
- ENotes

- Email verification is required before login
- Google Maps API key must be configured
- All Firebase configuration files are excluded from version control for security
Songa7273
