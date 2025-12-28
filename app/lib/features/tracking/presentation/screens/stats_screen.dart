import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../domain/entities/entry.dart';
import '../../domain/entities/measurement.dart';
import '../providers/entry_provider.dart';
import '../providers/measurement_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _TodaySummary(),
          SizedBox(height: 24),
          _GrowthChart(),
          SizedBox(height: 24),
          _FeedingChart(),
        ],
      ),
    );
  }
}

class _TodaySummary extends ConsumerWidget {
  const _TodaySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(todayEntriesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Summary",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (entries) => _buildSummary(context, entries),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, List<Entry> entries) {
    final feedings =
        entries.where((e) => e.type == EntryType.feeding).toList();
    final diapers = entries.where((e) => e.type == EntryType.diaper).toList();
    final sleeps = entries.where((e) => e.type == EntryType.sleep).toList();

    // Calculate totals
    final totalOz = feedings
        .where((e) => e.amount != null)
        .fold<double>(0, (sum, e) => sum + e.amount!);

    final totalSleepMinutes = sleeps
        .where((e) => e.sleepDuration != null)
        .fold<int>(0, (sum, e) => sum + e.sleepDuration!.inMinutes);

    final wetDiapers = diapers
        .where((e) => e.diaperType == DiaperType.wet || e.diaperType == DiaperType.both)
        .length;
    final dirtyDiapers = diapers
        .where((e) => e.diaperType == DiaperType.dirty || e.diaperType == DiaperType.both)
        .length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _SummaryItem(
          icon: Icons.restaurant,
          color: AppColors.feeding,
          value: '${feedings.length}',
          label: 'Feedings',
          detail: totalOz > 0 ? '${totalOz.toStringAsFixed(1)} oz' : null,
        ),
        _SummaryItem(
          icon: Icons.baby_changing_station,
          color: AppColors.diaper,
          value: '${diapers.length}',
          label: 'Diapers',
          detail: '$wetDiapers wet, $dirtyDiapers dirty',
        ),
        _SummaryItem(
          icon: Icons.bedtime,
          color: AppColors.sleep,
          value: '${sleeps.length}',
          label: 'Naps',
          detail: totalSleepMinutes > 0
              ? '${totalSleepMinutes ~/ 60}h ${totalSleepMinutes % 60}m'
              : null,
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    this.detail,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        if (detail != null) ...[
          const SizedBox(height: 2),
          Text(
            detail!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ],
    );
  }
}

class _GrowthChart extends ConsumerWidget {
  const _GrowthChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementsAsync = ref.watch(measurementsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Growth',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: measurementsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (measurements) => measurements.isEmpty
                    ? _buildEmptyState(context)
                    : _buildChart(context, measurements),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.straighten, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(
            'No measurements yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<Measurement> measurements) {
    // Sort by date ascending
    final sorted = [...measurements]..sort((a, b) => a.date.compareTo(b.date));

    // Filter to only those with weight
    final withWeight = sorted.where((m) => m.weightOz != null).toList();

    if (withWeight.isEmpty) {
      return _buildEmptyState(context);
    }

    // Create spots for the chart
    final spots = withWeight.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.weightLbs ?? 0,
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= withWeight.length) {
                  return const SizedBox.shrink();
                }
                final date = withWeight[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.month}/${date.day}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()} lbs',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.growth,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.growth,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.growth.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.spotIndex;
                final measurement = withWeight[index];
                return LineTooltipItem(
                  '${measurement.formatWeight()}\n${measurement.date.month}/${measurement.date.day}/${measurement.date.year}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

class _FeedingChart extends ConsumerWidget {
  const _FeedingChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(allEntriesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feedings (Last 7 Days)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: entriesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (entries) => _buildChart(context, entries),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<Entry> allEntries) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get feeding counts for last 7 days
    final counts = List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      final nextDate = date.add(const Duration(days: 1));
      return allEntries
          .where((e) =>
              e.type == EntryType.feeding &&
              e.timestamp.isAfter(date.subtract(const Duration(seconds: 1))) &&
              e.timestamp.isBefore(nextDate))
          .length;
    });

    final maxY = (counts.reduce((a, b) => a > b ? a : b) + 2).toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = today.subtract(Duration(days: 6 - group.x.toInt()));
              return BarTooltipItem(
                '${rod.toY.toInt()} feedings\n${date.month}/${date.day}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == value.toInt()) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final date = today.subtract(Duration(days: 6 - value.toInt()));
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    dayNames[date.weekday - 1],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
        ),
        barGroups: List.generate(7, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: counts[i].toDouble(),
                color: AppColors.feeding,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
