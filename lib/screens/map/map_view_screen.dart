import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/listings_provider.dart';
import '../../models/service_listing.dart';
import '../detail/detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? _mapController;
  final LatLng _kigaliCenter = const LatLng(-1.9441, 30.0619);

  double _getMarkerColor(String category) {
    switch (category) {
      case 'Hospital':
        return BitmapDescriptor.hueRed;
      case 'Police Station':
        return BitmapDescriptor.hueBlue;
      case 'Library':
        return BitmapDescriptor.hueViolet;
      case 'Restaurant':
        return BitmapDescriptor.hueOrange;
      case 'Café':
        return BitmapDescriptor.hueYellow;
      case 'Park':
        return BitmapDescriptor.hueGreen;
      case 'Tourist Attraction':
        return BitmapDescriptor.hueCyan;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: Consumer<ListingsProvider>(
        builder: (context, provider, child) {
          // Update markers based on current listings without setState
          final listings = provider.allListings;
          final markers = listings.map((listing) {
            return Marker(
              markerId: MarkerId(listing.id ?? ''),
              position: LatLng(listing.latitude, listing.longitude),
              infoWindow: InfoWindow(
                title: listing.name,
                snippet: listing.category,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(listing: listing),
                    ),
                  );
                },
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                _getMarkerColor(listing.category),
              ),
            );
          }).toSet();
          
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _kigaliCenter,
              zoom: 12,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
