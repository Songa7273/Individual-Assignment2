/// Data model representing a service listing in the Kigali Services Directory.
/// 
/// Each listing contains information about a service location including name,
/// category, contact details, geographical coordinates, and metadata about
/// who created it and when.
class ServiceListing {
  /// Unique identifier for the listing (Firestore document ID)
  final String? id;
  
  /// Name of the service or business
  final String name;
  
  /// Category of service (e.g., Hospital, Restaurant, Library)
  final String category;
  
  /// Physical address of the service
  final String address;
  
  /// Contact phone number for the service
  final String contactNumber;
  
  /// Detailed description of the service
  final String description;
  
  /// Latitude coordinate for map display
  final double latitude;
  
  /// Longitude coordinate for map display
  final double longitude;
  
  /// User ID of the person who created this listing
  final String createdBy;
  
  /// Timestamp when the listing was created
  final DateTime timestamp;

  ServiceListing({
    this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.timestamp,
  });

  /// Converts the ServiceListing object to a Map for Firestore storage.
  /// 
  /// Timestamp is converted to ISO 8601 string format for consistent storage.
  /// The id field is not included as it's managed by Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'contactNumber': contactNumber,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Creates a ServiceListing object from Firestore document data.
  /// 
  /// [id] The Firestore document ID
  /// [map] The document data as a Map
  /// 
  /// Provides default values for missing fields to prevent null errors.
  /// Converts numeric types to double for coordinate values.
  factory ServiceListing.fromMap(String id, Map<String, dynamic> map) {
    return ServiceListing(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      address: map['address'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      description: map['description'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      createdBy: map['createdBy'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  /// Creates a copy of this ServiceListing with optionally updated fields.
  /// 
  /// Useful for updating specific fields while keeping others unchanged.
  /// Any null parameter will use the current value from this instance.
  ServiceListing copyWith({
    String? id,
    String? name,
    String? category,
    String? address,
    String? contactNumber,
    String? description,
    double? latitude,
    double? longitude,
    String? createdBy,
    DateTime? timestamp,
  }) {
    return ServiceListing(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      contactNumber: contactNumber ?? this.contactNumber,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdBy: createdBy ?? this.createdBy,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
