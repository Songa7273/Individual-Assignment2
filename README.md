# Kigali Services Directory 🏙️

A Flutter mobile app for discovering and managing local services in Kigali, Rwanda. Built as part of my mobile app development coursework.

## What This App Does

Ever struggled to find a hospital, police station, or good restaurant in Kigali? Yeah, me too. That's why I built this directory app where you can:

- **Browse services** - Search through listings by name or filter by category
- **Add your own** - Know a great café? Add it to help others find it too
- **See on a map** - View exact locations with integrated map functionality  
- **Manage your contributions** - Edit or delete listings you've created

## The Tech Stack

- **Flutter** - For the cross-platform mobile UI
- **Firebase Auth** - User authentication with email verification
- **Cloud Firestore** - Real-time NoSQL database for storing listings
- **Provider** - State management (way cleaner than setState everywhere!)
- **Google Maps** - Location display and navigation

## Development Journey

### Week 1: The Foundation
Started with the basics - set up Firebase, got authentication working. Email verification was a bit tricky but figured it out. Created the data models for users and service listings.

### Week 2: Core Features
Built out the main screens and CRUD operations. Getting the Firestore streams to work with Provider took some time, but once I got it, everything just clicked. The real-time updates are pretty cool actually.

### Week 3: Making It Better
This week was all about polish and user experience:

- **Pull-to-refresh** - Because nobody likes stale data. Added it to the directory screen so users can manually refresh the listings.

- **Loading skeletons** - Those shimmer placeholders you see in modern apps? Added those instead of boring spinners. Makes the app feel way more responsive.

- **Search debouncing** - Without this, the search was firing on every keystroke and it felt janky. Now it waits 300ms after you stop typing. Much smoother.

- **Better empty states** - Instead of just saying "No data", I added helpful empty state screens with icons and action buttons to guide users on what to do next.

- **Error handling** - Added retry buttons for when things go wrong (because networks fail, it happens). Users can now tap to retry instead of being stuck.

- **Form validation** - Beefed up the validation with proper regex patterns and helpful error messages. Phone numbers, coordinates, everything gets validated properly now.

- **Visual feedback** - Implemented color-coded snackbars (green for success, red for errors) with icons. Much better than plain text notifications.

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── service_listing.dart  # Service listing structure
│   └── user_profile.dart     # User profile data
├── providers/                # State management
│   ├── auth_provider.dart    # Authentication state
│   └── listings_provider.dart # Listings data & filters
├── services/                 # Backend logic
│   ├── auth_service.dart     # Firebase Auth operations
│   └── firestore_service.dart # Database CRUD
├── screens/                  # UI screens
│   ├── auth/                 # Login & signup
│   ├── directory/            # Browse listings
│   ├── my_listings/          # User's own listings
│   ├── detail/               # Service details
│   ├── map/                  # Map view
│   └── settings/             # App settings
├── widgets/                  # Reusable components
│   ├── listing_skeleton.dart # Loading placeholder
│   ├── empty_state_widget.dart # Empty state display
│   └── error_retry_widget.dart # Error handling
└── utils/                    # Helper functions
    ├── constants.dart        # App constants
    ├── form_validators.dart  # Input validation
    └── snackbar_helper.dart  # Notification helpers
```

## Features I'm Proud Of

1. **Real-time updates** - When someone adds a listing, you see it immediately. No refresh needed.

2. **Smart search** - Debounced search with category filters. Found the sweet spot at 300ms delay.

3. **User feedback** - Every action gives clear feedback. Success? Green snackbar. Error? Red with a retry button.

4. **Validation** - Phone numbers, emails, coordinates - everything is validated with helpful error messages that actually tell you what's wrong.

5. **Loading states** - No more blank screens. Skeletons show while data loads, empty states guide when there's no data.

## Challenges & Solutions

**Challenge 1: Authentication Flow**  
Firebase auth was straightforward, but handling email verification took some thought. Solved it by checking verification status on login and showing clear messages to users.

**Challenge 2: Provider vs Bloc**  
Initially considered using Bloc, but Provider felt more intuitive for this project size. The Consumer widgets make the UI updates really clean.

**Challenge 3: Form Validation**  
Started with simple null checks, but that gave terrible UX. Created a dedicated validators utility with regex patterns for emails, phones, coordinates. Much better now.

**Challenge 4: Performance**  
Search was laggy when typing fast. Added debouncing to wait until user stops typing. Night and day difference.

## What I Learned

- Firebase is actually pretty awesome for rapid prototyping
- Provider makes state management much cleaner than passing callbacks everywhere
- Good error states and loading indicators make or break the UX
- Validation is annoying to implement but absolutely necessary
- 300ms is the magic number for debouncing (tried 500ms, felt sluggish; tried 100ms, still too many requests)

## Running the Project

1. Clone the repo
2. Install dependencies: `flutter pub get`
3. Set up Firebase (add your `google-services.json` and `GoogleService-Info.plist`)
4. Run: `flutter run`

## Firebase Setup (Quick Version)

1. Create a Firebase project
2. Enable Email/Password authentication
3. Create a Firestore database
4. Add these security rules:

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

## Future Improvements

If I had more time, I'd add:
- Image uploads for listings
- User ratings and reviews
- Advanced filters (open now, distance, etc.)
- Offline support with cached data
- Push notifications for nearby services

## Reflection

This project taught me a lot about building real-world apps. It's one thing to follow tutorials, but actually architecting an app from scratch, handling edge cases, and making it feel polished - that's where the real learning happens.

The code might not be perfect (I'm still learning!), but I'm pretty happy with how it turned out. The app actually solves a real problem and feels smooth to use.

The iterative improvements I made in week 3 really drove home the importance of UX. Those little touches - loading states, error handling, visual feedback - they're what separate a working app from a *good* app.

---

**Built with ☕ and lots of Stack Overflow**  
*Because let's be honest, we all use it*

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
