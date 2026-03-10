import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_listing.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'listings';

  Stream<List<ServiceListing>> getAllListings() {
    return _firestore
        .collection(collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceListing.fromMap(doc.id, doc.data()))
            .toList());
  }

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

  Future<void> createListing(ServiceListing listing) async {
    await _firestore.collection(collection).add(listing.toMap());
  }

  Future<void> updateListing(String id, ServiceListing listing) async {
    await _firestore.collection(collection).doc(id).update(listing.toMap());
  }

  Future<void> deleteListing(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

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
