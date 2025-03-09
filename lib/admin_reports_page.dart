import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/data_service.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  String _selectedPeriod = 'Day';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final now = DateTime.now();
        final startDate = _getStartDate(now);
        final report = dataService.getFinancialReport(
          startDate: startDate,
          endDate: now,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Selection
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Day', label: Text('Day')),
                  ButtonSegment(value: 'Week', label: Text('Week')),
                  ButtonSegment(value: 'Month', label: Text('Month')),
                  ButtonSegment(value: 'Year', label: Text('Year')),
                ],
                selected: {_selectedPeriod},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedPeriod = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Summary Cards
              Row(
                children: [
                  _buildSummaryCard(
                    'Total Sales',
                    '\$${report['totalSales'].toStringAsFixed(2)}',
                    Icons.attach_money,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    'Orders',
                    report['orderCount'].toString(),
                    Icons.receipt_long,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    'Avg Order Value',
                    '\$${report['averageOrderValue'].toStringAsFixed(2)}',
                    Icons.analytics,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Charts
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sales Trend',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: LineChart(
                              // Implement chart data
                              LineChartData(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Popular Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: BarChart(
                              // Implement chart data
                              BarChartData(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Inventory Alerts
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Low Stock Alerts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...dataService.getLowStockAlerts().map(
                          (alert) => ListTile(
                            leading:
                                const Icon(Icons.warning, color: Colors.amber),
                            title: Text(
                              '${alert['item']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Current: ${alert['quantity']} ${alert['unit']} (Min: ${alert['minStock']} ${alert['unit']})',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            trailing: FilledButton.icon(
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('Restock'),
                              onPressed: () {
                                // Implement restock functionality
                              },
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  DateTime _getStartDate(DateTime now) {
    switch (_selectedPeriod) {
      case 'Day':
        return DateTime(now.year, now.month, now.day);
      case 'Week':
        return now.subtract(const Duration(days: 7));
      case 'Month':
        return DateTime(now.year, now.month, 1);
      case 'Year':
        return DateTime(now.year, 1, 1);
      default:
        return now;
    }
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
