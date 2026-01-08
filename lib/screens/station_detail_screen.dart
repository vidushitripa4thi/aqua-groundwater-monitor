import 'package:flutter/material.dart';
import '../models/dwlr_station.dart';
import '../widgets/charts/water_level_chart.dart';

class StationDetailScreen extends StatefulWidget {
  final DWLRStation station;

  const StationDetailScreen({super.key, required this.station});

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share station details
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Export data
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Trends', icon: Icon(Icons.show_chart)),
            Tab(text: 'Analysis', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildTrendsTab(),
          _buildAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Station Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Location', '${widget.station.district}, ${widget.station.state}'),
                _buildInfoRow('Latitude', widget.station.latitude.toStringAsFixed(4)),
                _buildInfoRow('Longitude', widget.station.longitude.toStringAsFixed(4)),
                _buildInfoRow('Elevation', '${widget.station.elevation} m'),
                _buildInfoRow('Aquifer Type', widget.station.aquiferType),
                _buildInfoRow('Status', widget.station.isActive ? 'Active' : 'Inactive'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Reading',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Loading current data...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendsTab() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: WaterLevelChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recharge Analysis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Seasonal recharge patterns and forecasts will appear here.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
