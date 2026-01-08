import 'package:flutter/foundation.dart';
import '../../models/dwlr_station.dart';
import '../api_service.dart';

class DataProvider with ChangeNotifier {
  final APIService _apiService = APIService();
  
  List<DWLRStation> _stations = [];
  bool _isLoading = false;
  String? _error;

  List<DWLRStation> get stations => _stations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalStations => _stations.length;
  int get criticalStationsCount => _stations
      .where((s) => !s.isActive)
      .length; // Simplified for demo

  Future<void> loadStations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stations = await _apiService.fetchAllStations();
      _error = null;
    } catch (e) {
      _error = 'Failed to load stations: $e';
      // Load sample data for demo
      _stations = _generateSampleData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DWLRStation> _generateSampleData() {
    // Sample data for demonstration
    return List.generate(
      10,
      (index) => DWLRStation(
        id: 'station_$index',
        name: 'DWLR Station ${index + 1}',
        state: index % 2 == 0 ? 'Maharashtra' : 'Karnataka',
        district: 'District ${index + 1}',
        latitude: 20.5937 + (index * 0.5),
        longitude: 78.9629 + (index * 0.5),
        elevation: 500 + (index * 10),
        aquiferType: index % 2 == 0 ? 'Alluvial' : 'Hard Rock',
        installationDate: DateTime(2020, 1, 1),
        isActive: index % 3 != 0,
      ),
    );
  }
}
