import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_nutrition/providers/providers.dart';

/// Progress tracking tab with charts and statistics
class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  @override
  void initState() {
    super.initState();
    // Initialize demo data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().initializeDemoData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats cards row
        _buildStatsCards(),
        const SizedBox(height: 24),

        // Weight progress chart
        _buildWeightChart(),
        const SizedBox(height: 24),

        // Activity heatmap
        _buildActivitySection(),
        const SizedBox(height: 24),

        // Weekly summary
        _buildWeeklySummary(),
      ],
    );
  }

  /// Build quick stats cards
  Widget _buildStatsCards() {
    return Consumer<ProgressProvider>(
      builder: (context, progress, _) {
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Weight Lost',
                '${progress.weightLost.abs().toStringAsFixed(1)} kg',
                Icons.trending_down,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Current Streak',
                '${progress.currentStreak} days',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build weight progress chart
  Widget _buildWeightChart() {
    return Consumer<ProgressProvider>(
      builder: (context, progress, _) {
        if (progress.weightHistory.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Weight Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${progress.currentWeight?.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withValues(alpha: 0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 7,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() % 7 == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Day ${value.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()} kg',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: progress.weightHistory.length.toDouble() - 1,
                      minY: progress.weightHistory
                              .map((e) => e.weight)
                              .reduce((a, b) => a < b ? a : b) -
                          1,
                      maxY: progress.weightHistory
                              .map((e) => e.weight)
                              .reduce((a, b) => a > b ? a : b) +
                          1,
                      lineBarsData: [
                        LineChartBarData(
                          spots: progress.weightHistory
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.weight,
                                  ))
                              .toList(),
                          isCurved: true,
                          color: const Color(0xFF4CAF50),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: const Color(0xFF4CAF50),
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color:
                                const Color(0xFF4CAF50).withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build activity heatmap section
  Widget _buildActivitySection() {
    return Consumer<ProgressProvider>(
      builder: (context, progress, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activity Heatmap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Last 30 days',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _buildActivityGrid(progress),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build activity grid (heatmap)
  Widget _buildActivityGrid(ProgressProvider progress) {
    final activities = progress.activityHistory;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: activities.map((activity) {
        final intensity = activity.activityScore;
        final color = _getHeatmapColor(intensity);

        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '${activity.date.day}',
              style: TextStyle(
                fontSize: 10,
                color: intensity > 2 ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getHeatmapColor(int intensity) {
    if (intensity == 0) return Colors.grey[200]!;
    if (intensity <= 2) return const Color(0xFF4CAF50).withValues(alpha: 0.3);
    if (intensity <= 4) return const Color(0xFF4CAF50).withValues(alpha: 0.6);
    return const Color(0xFF4CAF50);
  }

  /// Build weekly summary
  Widget _buildWeeklySummary() {
    return Consumer<ProgressProvider>(
      builder: (context, progress, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryRow(
                  Icons.fitness_center,
                  'Workouts Completed',
                  '${progress.thisWeekWorkouts}',
                  Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  Icons.local_fire_department,
                  'Calories Burned',
                  '${progress.thisWeekCalories.toStringAsFixed(0)} kcal',
                  Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  Icons.trending_down,
                  'Weight Change',
                  '${progress.weightLost.toStringAsFixed(1)} kg',
                  Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
