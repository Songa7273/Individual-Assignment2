/// Firestore database service for service listings operations.
/// 
/// Handles all CRUD operations and real-time data streaming for service listings.
/// Provides methods to fetch all listings, user-specific listings, and individual
/// listing details from the Firestore database.
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_listing.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Firestore collection name for service listings
  final String collection = 'listings';

  /// Returns a stream of all service listings ordered by timestamp.
  /// 
  /// Listings are ordered from newest to oldest (descending).
  /// Updates automatically when data changes in Firestore.
  Stream<List<ServiceListing>> getAllListings() {
    return _firestore
        .collection(collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceListing.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Returns a stream of listings created by a specific user.
  /// 
  /// [uid] The unique identifier of the user
  /// 
  /// Listings are ordered from newest to oldest (descending).
  /// Updates automatically when data changes in Firestore.
  Stream<List<ServiceListing>> getUserListings(String uid) {
    return _firestore
        .collection(collection)
        .where('createdBy', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceListing.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Creates a new service listing in Firestore.
  /// 
  /// [listing] The service listing to create
  /// 
  /// Firestore will automatically generate a unique document ID.
  Future<void> createListing(ServiceListing listing) async {
    await _firestore.collection(collection).add(listing.toMap());
  }

  /// Updates an existing service listing in Firestore.
  /// 
  /// [id] The Firestore document ID of the listing to update
  /// [listing] The updated listing data
  Future<void> updateListing(String id, ServiceListing listing) async {
    await _firestore.collection(collection).doc(id).update(listing.toMap());
  }

  /// Deletes a service listing from Firestore.
  /// 
  /// [id] The Firestore document ID of the listing to delete
  Future<void> deleteListing(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  /// Retrieves a single service listing by ID.
  /// 
  /// [id] The Firestore document ID of the listing to fetch
  /// 
  /// Returns the ServiceListing if found, null otherwise.
  Future<ServiceListing?> getListing(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        return ServiceListing.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
