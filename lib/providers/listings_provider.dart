/// Provider for managing service listings data and operations.
/// 
/// Handles fetching, filtering, searching, and CRUD operations for service listings.
/// Manages both all listings (for directory view) and user-specific listings.
/// Uses ChangeNotifier to update UI when data changes.
import 'package:flutter/material.dart';
import '../models/service_listing.dart';
import '../services/firestore_service.dart';

class ListingsProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  // Private state variables
  List<ServiceListing> _allListings = [];
  List<ServiceListing> _userListings = [];
  List<ServiceListing> _filteredListings = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Public getters for accessing state
  
  /// Filtered list of all listings based on search and category
  List<ServiceListing> get allListings => _filteredListings;
  
  /// Listings created by the current user
  List<ServiceListing> get userListings => _userListings;
  
  /// Whether a CRUD operation is in progress
  bool get isLoading => _isLoading;
  
  /// Current error message, if any
  String? get errorMessage => _errorMessage;
  
  /// Current search query text
  String get searchQuery => _searchQuery;
  
  /// Currently selected category filter
  String get selectedCategory => _selectedCategory;

  /// Available service categories for filtering
  final List<String> categories = [
    'All',
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
  ];

  /// Subscribes to real-time updates of all service listings.
  /// 
  /// Automatically applies current search and category filters when data changes.
  void listenToAllListings() {
    _firestoreService.getAllListings().listen((listings) {
      _allListings = listings;
      _applyFilters();
    });
  }

  /// Subscribes to real-time updates of listings created by a specific user.
  /// 
  /// [uid] The user's unique identifier
  void listenToUserListings(String uid) {
    _firestoreService.getUserListings(uid).listen((listings) {
      _userListings = listings;
      notifyListeners();
    });
  }

  /// Updates the search query and reapplies filters.
  /// 
  /// [query] The search text to filter listings by name
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Updates the category filter and reapplies filters.
  /// 
  /// [category] The category to filter by (use 'All' to show all categories)
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// Applies current search and category filters to the listings.
  /// 
  /// Filters are case-insensitive for search queries.
  /// Updates [_filteredListings] and notifies listeners.
  void _applyFilters() {
    _filteredListings = _allListings.where((listing) {
      // Check if listing name contains search query (case-insensitive)
      bool matchesSearch = _searchQuery.isEmpty ||
          listing.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Check if listing matches selected category
      bool matchesCategory = _selectedCategory == 'All' ||
          listing.category == _selectedCategory;
      
      // Both conditions must be true for listing to appear
      return matchesSearch && matchesCategory;
    }).toList();
    
    notifyListeners();
  }

  /// Creates a new service listing in Firestore.
  /// 
  /// [listing] The service listing to create
  /// 
  /// Sets [isLoading] during operation and [errorMessage] if an error occurs.
  Future<void> createListing(ServiceListing listing) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.createListing(listing);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Updates an existing service listing in Firestore.
  /// 
  /// [id] The Firestore document ID of the listing to update
  /// [listing] The updated listing data
  /// 
  /// Sets [isLoading] during operation and [errorMessage] if an error occurs.
  Future<void> updateListing(String id, ServiceListing listing) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.updateListing(id, listing);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Deletes a service listing from Firestore.
  /// 
  /// [id] The Firestore document ID of the listing to delete
  /// 
  /// Sets [isLoading] during operation and [errorMessage] if an error occurs.
  Future<void> deleteListing(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.deleteListing(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
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
