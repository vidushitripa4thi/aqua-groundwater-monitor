import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/providers/data_provider.dart';
import '../widgets/charts/water_level_chart.dart';
import '../widgets/cards/station_summary_card.dart';
import 'map_screen.dart';
import 'station_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().loadStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aqua Groundwater Monitor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (dataProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(dataProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => dataProvider.loadStations(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => dataProvider.loadStations(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary Cards
                _buildSummaryCards(dataProvider),
                const SizedBox(height: 24),

                // Critical Stations Alert
                if (dataProvider.criticalStationsCount > 0)
                  _buildCriticalAlert(dataProvider),

                // Recent Stations
                const Text(
                  'Recent Stations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...dataProvider.stations.take(5).map(
                      (station) => StationSummaryCard(
                        station: station,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StationDetailScreen(station: station),
                            ),
                          );
                        },
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(DataProvider dataProvider) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.water_drop, size: 32, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    '${dataProvider.totalStations}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Total Stations'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.warning, size: 32, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    '${dataProvider.criticalStationsCount}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const Text('Critical'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriticalAlert(DataProvider dataProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${dataProvider.criticalStationsCount} stations have critical water levels',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to critical stations list
            },
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}
