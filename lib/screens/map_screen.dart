import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/providers/data_provider.dart';
import '../models/dwlr_station.dart';
import 'station_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  // Center of India (approximate)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 5,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createMarkers();
    });
  }

  void _createMarkers() {
    final dataProvider = context.read<DataProvider>();
    final stations = dataProvider.stations;

    setState(() {
      _markers = stations.map((station) {
        return Marker(
          markerId: MarkerId(station.id),
          position: LatLng(station.latitude, station.longitude),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: '${station.district}, ${station.state}',
            onTap: () => _onMarkerTapped(station),
          ),
          icon: _getMarkerIcon(station),
        );
      }).toSet();
    });
  }

  BitmapDescriptor _getMarkerIcon(DWLRStation station) {
    // Color-code markers based on water level status
    // In production, you'd fetch current reading to determine status
    return BitmapDescriptor.defaultMarkerWithHue(
      station.isActive ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed,
    );
  }

  void _onMarkerTapped(DWLRStation station) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationDetailScreen(station: station),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
              _showFilterSheet();
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapType: MapType.normal,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'legend',
            mini: true,
            onPressed: _showLegend,
            child: const Icon(Icons.info_outline),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'refresh',
            mini: true,
            onPressed: _createMarkers,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Stations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.water_drop, color: Colors.green),
                title: const Text('Good Status'),
                onTap: () {
                  // Apply filter
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.water_drop, color: Colors.orange),
                title: const Text('Moderate Status'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.water_drop, color: Colors.red),
                title: const Text('Critical Status'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLegend() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Map Legend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLegendItem(Colors.green, 'Good - Water level normal'),
              _buildLegendItem(Colors.orange, 'Moderate - Needs monitoring'),
              _buildLegendItem(Colors.red, 'Critical - Immediate attention'),
              _buildLegendItem(Colors.grey, 'Inactive - Station offline'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(Color color, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }
}
